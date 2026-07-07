#!/usr/bin/env bash
set -euo pipefail

home_dir=${1:?home directory is required}
user_name=${2:?user name is required}
image_dotfiles_dir=/opt/dotfiles
home_dotfiles_dir="${home_dir}/_"
dotfiles_dir=${image_dotfiles_dir}

install_vim_plugins=${INSTALL_VIM_PLUGINS:-0}
identity=${IDENTITY:?identity is required}

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

mkdir -p "${home_dir}/Projects" "${home_dir}/Apps" "${home_dir}/Logs"
mkdir -p "${home_dir}/.vim"

if [[ -d "${home_dotfiles_dir}" ]]; then
    dotfiles_dir=${home_dotfiles_dir}
elif [[ -e "${home_dotfiles_dir}" ]]; then
    echo "${home_dotfiles_dir} exists and is not a directory or symbolic link" >&2
    exit 1
else
    safe_ln "${image_dotfiles_dir}" "${home_dotfiles_dir}"
fi

printf '%s\n' "${identity}" > "${dotfiles_dir}/identity"

safe_ln "${dotfiles_dir}/.zshrc" "${home_dir}/.zshrc"
safe_ln "${dotfiles_dir}/.gitconfig" "${home_dir}/.gitconfig"
safe_ln "${dotfiles_dir}/vim/vimrc" "${home_dir}/.vim/vimrc"

if [[ ! -d "${home_dir}/.oh-my-zsh" ]]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "${home_dir}/.oh-my-zsh"
fi

for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
    plugin_dir="${home_dir}/.oh-my-zsh/custom/plugins/${plugin}"
    if [[ ! -d "${plugin_dir}" ]]; then
        git clone --depth=1 "https://github.com/zsh-users/${plugin}.git" "${plugin_dir}"
    fi
done

if [[ ! -d "${home_dir}/.vim/autoload" ]]; then
    git clone --depth=1 https://github.com/junegunn/vim-plug.git "${home_dir}/.vim/autoload"
fi

if [[ "${install_vim_plugins}" == "1" ]]; then
    env VIMFILES="${home_dir}/.vim" VIMRC="${home_dir}/.vim/vimrc" \
        vim +'PlugInstall --sync' +qa
fi
