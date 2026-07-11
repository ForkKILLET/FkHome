#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/dotfiles-common.sh"

home_dir=${1:?home directory is required}
user_name=${2:?user name is required}
image_dotfiles_dir=/opt/dotfiles
home_dotfiles_dir="${home_dir}/_"
dotfiles_dir=${image_dotfiles_dir}

install_vim_plugins=${INSTALL_VIM_PLUGINS:-0}
identity=${IDENTITY:?identity is required}

if [[ -d "${home_dotfiles_dir}" ]]; then
    dotfiles_dir=${home_dotfiles_dir}
elif [[ -e "${home_dotfiles_dir}" ]]; then
    echo "${home_dotfiles_dir} exists and is not a directory or symbolic link" >&2
    exit 1
else
    safe_ln "${image_dotfiles_dir}" "${home_dotfiles_dir}"
fi

printf '%s\n' "${identity}" > "${dotfiles_dir}/identity"

install_common_dotfiles "${dotfiles_dir}" "${home_dir}"

if [[ "${install_vim_plugins}" == "1" ]]; then
    env VIMFILES="${home_dir}/.vim" VIMRC="${home_dir}/.vim/vimrc" \
        vim +'PlugInstall --sync' +qa
fi
