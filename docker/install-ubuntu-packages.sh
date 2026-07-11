#!/usr/bin/env bash
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

apt-get update

required_packages=(
    bash
    ca-certificates
    curl
    git
    sudo
    zsh
    docker.io
    proxychains-ng
)

# Ubuntu package names corresponding to packages.cliPkgs in nixos/packages.nix.
# Packages that are not present in the enabled Ubuntu repositories are skipped
# below instead of failing the whole image build.
candidate_packages=(
    bat
    bc
    duf
    fd-find
    fastfetch
    fzf
    gh
    git-delta
    hexyl
    httpie
    jq
    lsd
    lsof
    p7zip-full
    procs
    rename
    ripgrep
    rlwrap
    screen
    sqlite3
    tealdeer
    tree
    unrar
    unrar-free
    unzip
    vim
    wget
    zip
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

if ((${#missing_packages[@]})); then
    printf 'Skipped packages without Ubuntu candidates: %s\n' "${missing_packages[*]}"
fi

