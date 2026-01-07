#!/usr/bin/env zsh

# utils

export LEVEL=${LEVEL:-0}
export INDENT_UNIT="    "
export INDENT=""
export TEST

ERROR_COUNT=0

update_indent() {
    INDENT=""
    for ((i = 0; i < LEVEL; i++)); do
        INDENT="${INDENT}${INDENT_UNIT}"
    done
}

level() {
    local cmd=$1
    local msg=$2

    if [[ -n $msg ]]; then
        output_section "$msg"
    fi

    (
        LEVEL=$((LEVEL + 1))
        update_indent
        eval $cmd
    )
    
    local ret=$?
    if ((ret != 0)); then
        ERROR_COUNT=$((ERROR_COUNT + 1))
    fi

    return $ret
}

output() {
    local msg=$1
    shift

    echo $@ "$INDENT$msg"
}

error() {
    local msg=$1
    shift

    ERROR_COUNT=$((ERROR_COUNT + 1))
    output "\x1B[31m$msg\x1B[0m" $@ >&2

    exit 1
}

check_env() {
    local env=$1
    if [[ -z ${(P)env} ]]; then
        error "\$$env not set"
    fi
}

output_section() {
    local msg=$1
    shift

    output "\x1B[1;32m#\x1B[0;32m $msg\x1B[0m" $@
}

output_exec() {
    output "\x1B[1;34m\$\x1B[0;34m $*\x1B[0m"
    if [[ -z $TEST ]]; then
        $@
        local ret=$?
        if ((ret != 0)); then
            error "Command failed with $ret"
        fi
    fi
}

confirm() {
    local prompt=$1
    local default=$2

    case $default in
        [Yy] ) prompt="$prompt\x1B[0m (Y/n)" ;;
        [Nn] ) prompt="$prompt\x1B[0m (y/N)" ;;
        * ) prompt="$prompt\x1B[0m (y/n)" ;;
    esac

    while true; do
        output_section "$prompt " -n
        read answer

        case ${answer:-$default} in
            [Yy]* ) return 0 ;;
            [Nn]* ) return 1 ;;
            * ) ;;
        esac
    done
}

safe_ln() {
    local src="$1"
    local dst="$2"

    if [[ -e $dst ]]; then
        if [[ -L $dst ]]; then
            rm "$dst"
        else
            error "$dst exists and is not symbolic link"
            return 1
        fi
    fi

    ln -s "$src" "$dst"
}

level_safe_ln() {
    local src=$1
    local dst=$2
    local file=${src##~/_/}
    level "output_exec safe_ln $src $dst" "Linking $file"
}

# enter dash directory

cd ~/_

# construct directories

construct_directories() {
    output_exec mkdir -p ~/{Projects,Apps,Logs}
}

level construct_directories "Constructing dirctories"

# link files

link_files() {
    local files=(.zshrc .gitconfig)

    for file in $files; do
        level_safe_ln ~/_/$file ~/$file
    done
}

level link_files "Linking files"

# source .zshrc

output_section "Loading .zshrc"
source .zshrc

# install oh-my-zsh

install_oh_my_zsh__install_self() {
    check_env ZSH

    if [[ -e $ZSH ]]; then
        output "oh-my-zsh already exists at $ZSH"
        return 0
    fi

    output_exec git clone "https://github.com/robbyrussell/oh-my-zsh.git" $ZSH
}

install_oh_my_zsh__install_plugin_zsh_syntax_highlighting() {
    output_exec git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" $ZSH/custom/plugins/zsh-syntax-highlighting
}

install_oh_my_zsh() {
    level install_oh_my_zsh__install_self "Installing oh-my-zsh" && \
    level install_oh_my_zsh__install_plugin_zsh_syntax_highlighting "Installing plugin zsh-syntax-highlighting"
}

if confirm "Installing oh-my-zsh?"; then
    level install_oh_my_zsh
fi

# configure vim

configure_vim__construct_directories() {
    output_exec mkdir ~/.vim
}

configure_vim__link_files() {
    local files=(vimrc)

    for file in $files; do
        level_safe_ln ~/_/vim/$file ~/.vim/$file
    done
}

configure_vim__install_vim_plug() {
    local autoload=~/.vim/autoload

    if [[ -e $autoload ]]; then
        output "autoload directory already exists at $autoload"
        return 0
    fi

    output_exec git clone https://github.com/junegunn/vim-plug.git ~/.vim/autoload
}

configure_vim() {
    level configure_vim__construct_directories "Constructing dirctories" && \
    level configure_vim__link_files "Linking files" && \
    level configure_vim__install_vim_plug "Installing vim-plug"
}

if confirm "Configuring vim?"; then
    level configure_vim
fi

# configure fcitx

configure_fcitx() {
    check_env XDG_CONFIG_HOME
    check_env XDG_DATA_HOME

    local config_files=(config conf)
    local data_files=(data rime/default.custom.yaml)

    for file in $config_files; do
        level_safe_ln ~/_/fcitx5/$file $XDG_CONFIG_HOME/fcitx5/$file
    done

    for file in $data_files; do
        level_safe_ln ~/_/fcitx5/$file $XDG_DATA_HOME/fcitx5/$file
    done
}

if confirm "Configuring fcitx5?"; then
    level configure_fcitx
fi

# done

output_section "Reloading .zshrc"
fk s

if [[ $ERROR_COUNT = 0 ]]; then
    output_section "Done"
else
    output_section "Done with \x1B[31m$ERROR_COUNT errors\x1B[0m"
fi
