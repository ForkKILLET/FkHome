#!/usr/bin/env bash
set -euo pipefail

dev_home=${1:?dev home directory is required}
root_home=/root
dotfiles_dir="${dev_home}/_"

safe_ln() {
    local src=$1
    local dst=$2

    if [[ -L "${dst}" ]]; then
        rm "${dst}"
    elif [[ -e "${dst}" ]]; then
        echo "${dst} exists and is not a symbolic link" >&2
        exit 1
    fi

    ln -s "${src}" "${dst}"
}

if [[ ! -d "${dotfiles_dir}" ]]; then
    echo "${dotfiles_dir} does not exist or is not a directory" >&2
    exit 1
fi

mkdir -p "${root_home}/Projects" "${root_home}/Apps" "${root_home}/Logs"
mkdir -p "${root_home}/.vim"

safe_ln "${dotfiles_dir}" "${root_home}/_"
safe_ln "${dotfiles_dir}/.zshrc" "${root_home}/.zshrc"
safe_ln "${dotfiles_dir}/.gitconfig" "${root_home}/.gitconfig"
safe_ln "${dotfiles_dir}/vim/vimrc" "${root_home}/.vim/vimrc"

if [[ ! -d "${root_home}/.oh-my-zsh" ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git "${root_home}/.oh-my-zsh"
fi

for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
    plugin_dir="${root_home}/.oh-my-zsh/custom/plugins/${plugin}"
    if [[ ! -d "${plugin_dir}" ]]; then
        git clone "https://github.com/zsh-users/${plugin}.git" "${plugin_dir}"
    fi
done

if [[ ! -d "${root_home}/.vim/autoload" ]]; then
    git clone https://github.com/junegunn/vim-plug.git "${root_home}/.vim/autoload"
fi
