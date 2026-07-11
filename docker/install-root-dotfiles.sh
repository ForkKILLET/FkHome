#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/dotfiles-common.sh"

dev_home=${1:?dev home directory is required}
root_home=/root
dotfiles_dir="${dev_home}/_"

if [[ ! -d "${dotfiles_dir}" ]]; then
    echo "${dotfiles_dir} does not exist or is not a directory" >&2
    exit 1
fi

safe_ln "${dotfiles_dir}" "${root_home}/_"
install_common_dotfiles "${dotfiles_dir}" "${root_home}"
