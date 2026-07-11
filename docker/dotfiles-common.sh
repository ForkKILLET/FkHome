#!/usr/bin/env bash

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

configure_git_proxy() {
    local home_dir=$1
    local http_proxy_value=${http_proxy:-${HTTP_PROXY:-}}
    local https_proxy_value=${https_proxy:-${HTTPS_PROXY:-}}
    local gitconfig_local="${home_dir}/.gitconfig-local"

    touch "${gitconfig_local}"

    if [[ -n "${http_proxy_value}" ]]; then
        git config --file "${gitconfig_local}" http.proxy "${http_proxy_value}"
    fi

    if [[ -n "${https_proxy_value}" ]]; then
        git config --file "${gitconfig_local}" https.proxy "${https_proxy_value}"
    fi
}

install_shell_tools() {
    local home_dir=$1
    local plugin
    local plugin_dir

    if [[ ! -d "${home_dir}/.oh-my-zsh" ]]; then
        git clone https://github.com/ohmyzsh/ohmyzsh.git "${home_dir}/.oh-my-zsh"
    fi

    for plugin in zsh-syntax-highlighting zsh-autosuggestions; do
        plugin_dir="${home_dir}/.oh-my-zsh/custom/plugins/${plugin}"
        if [[ ! -d "${plugin_dir}" ]]; then
            git clone "https://github.com/zsh-users/${plugin}.git" "${plugin_dir}"
        fi
    done

    if [[ ! -d "${home_dir}/.vim/autoload" ]]; then
        git clone https://github.com/junegunn/vim-plug.git "${home_dir}/.vim/autoload"
    fi
}

install_common_dotfiles() {
    local dotfiles_dir=$1
    local home_dir=$2

    mkdir -p "${home_dir}/Projects" "${home_dir}/Apps" "${home_dir}/Logs"
    mkdir -p "${home_dir}/.vim"

    safe_ln "${dotfiles_dir}/.zshrc" "${home_dir}/.zshrc"
    safe_ln "${dotfiles_dir}/.gitconfig" "${home_dir}/.gitconfig"
    safe_ln "${dotfiles_dir}/vim/vimrc" "${home_dir}/.vim/vimrc"

    configure_git_proxy "${home_dir}"
    install_shell_tools "${home_dir}"
}
