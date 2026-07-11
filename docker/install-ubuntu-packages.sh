#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update

required_packages=(
    bash
    ca-certificates
    curl
    docker.io
    git
    proxychains-ng
    sudo
    zsh
    ssh
)

# Ubuntu package names corresponding to packages.cliPkgs in nixos/packages.nix.
# Packages that are not present in the enabled Ubuntu repositories are skipped
# below instead of failing the whole image build.
candidate_packages=(
    bat
    bc
    duf
    dust
    fd-find
    fastfetch
    fzf
    gh
    git-delta
    httpie
    jq
    lsd
    lsof
    neovim
    p7zip-full
    procs
    rename
    ripgrep
    rlwrap
    screen
    sqlite3
    tokei
    tree
    unrar
    unrar-free
    unzip
    vim
    wget
    zip
    zstd
)

installable_packages=()
missing_packages=()

for package in "${candidate_packages[@]}"; do
    candidate=$(apt-cache policy "${package}" | awk '/Candidate:/ { print $2; exit }')
    if [[ -z "${candidate}" || "${candidate}" == "(none)" ]]; then
        missing_packages+=("${package}")
    else
        installable_packages+=("${package}")
    fi
done

apt-get install -y --no-install-recommends "${required_packages[@]}" "${installable_packages[@]}"

install_fzf_shell_integration() {
    local examples_dir=/usr/share/doc/fzf/examples
    local fzf_version

    if ! command -v fzf >/dev/null; then
        return
    fi

    fzf_version=$(fzf --version | awk '{ print $1 }')
    if [[ -z "${fzf_version}" ]]; then
        return
    fi

    mkdir -p "${examples_dir}"

    curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/${fzf_version}/shell/key-bindings.zsh" \
        -o "${examples_dir}/key-bindings.zsh"

    curl -fsSL "https://raw.githubusercontent.com/junegunn/fzf/${fzf_version}/shell/completion.zsh" \
        -o "${examples_dir}/completion.zsh"
}

install_fzf_shell_integration

if ((${#missing_packages[@]})); then
    printf 'Skipped packages without Ubuntu candidates: %s\n' "${missing_packages[*]}"
fi
