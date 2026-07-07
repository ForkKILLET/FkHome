#!/usr/bin/env bash
set -euo pipefail

dev_user=${DEV_USER:-dev}
dev_home=${DEV_HOME:-/home/${dev_user}}
dev_gid=${DEV_GID:-${dev_user}}
install_vim_plugins=${INSTALL_VIM_PLUGINS:-0}

run_as_dev() {
    if [[ "$(id -u)" != "0" ]]; then
        "$@"
        return
    fi

    sudo -H -u "${dev_user}" env \
        IDENTITY="${IDENTITY}" \
        INSTALL_VIM_PLUGINS="${INSTALL_VIM_PLUGINS}" \
        HTTP_PROXY="${HTTP_PROXY:-${http_proxy:-}}" \
        HTTPS_PROXY="${HTTPS_PROXY:-${https_proxy:-}}" \
        NO_PROXY="${NO_PROXY:-${no_proxy:-}}" \
        http_proxy="${http_proxy:-${HTTP_PROXY:-}}" \
        https_proxy="${https_proxy:-${HTTPS_PROXY:-}}" \
        no_proxy="${no_proxy:-${NO_PROXY:-}}" \
        "$@"
}

mkdir -p "${dev_home}"
if [[ "$(id -u)" == "0" ]]; then
    chown -R "${dev_user}:${dev_gid}" "${dev_home}"
fi

needs_dotfiles=0
needs_vim_plugins=0

if [[ \
    ! -e "${dev_home}/_" || \
    ! -e "${dev_home}/.zshrc" || \
    ! -e "${dev_home}/.gitconfig" || \
    ! -d "${dev_home}/.oh-my-zsh" || \
    ! -d "${dev_home}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" || \
    ! -d "${dev_home}/.oh-my-zsh/custom/plugins/zsh-autosuggestions" || \
    ! -d "${dev_home}/.vim/autoload" \
]]; then
    needs_dotfiles=1
fi

if [[ "${install_vim_plugins}" == "1" && ! -d "${dev_home}/.vim/plugged" ]]; then
    needs_vim_plugins=1
fi

if [[ "${needs_dotfiles}" == "1" || "${needs_vim_plugins}" == "1" ]]; then
    run_as_dev bash /opt/dotfiles/docker/install-dotfiles.sh "${dev_home}" "${dev_user}"
    if [[ "$(id -u)" == "0" ]]; then
        chown -R "${dev_user}:${dev_gid}" "${dev_home}"
    fi
fi

if [[ $# -eq 0 ]]; then
    set -- /usr/bin/zsh -l
fi

if [[ "$(id -u)" == "0" ]]; then
    exec sudo -H -u "${dev_user}" "$@"
fi

exec "$@"
