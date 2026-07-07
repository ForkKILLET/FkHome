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
)

# Ubuntu package names corresponding to packages.cliPkgs in nixos/packages.nix.
# Packages that are not present in the enabled Ubuntu repositories are skipped
# below instead of failing the whole image build.
candidate_packages=(
    bat
    bc
    bottom
    broot
    duf
    dust
    fd-find
    ffmpeg
    fastfetch
    fzf
    gh
    git-delta
    hexyl
    httpie
    jq
    lsd
    lsof
    neovim
    nil
    nushell
    p7zip-full
    procs
    rename
    ripgrep
    rlwrap
    screen
    sqlite3
    tealdeer
    tokei
    tree
    unrar
    unrar-free
    unrar-wrapper
    unzip
    vim
    wakatime
    wakatime-cli
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

apt-get clean
rm -rf /var/lib/apt/lists/*
