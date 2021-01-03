# tmp, w = fklx

export HOME="/c/_"
export H=$HOME

export VIM="$H/vim"
export VIMRC="$H/.vimrc"
export BASHRC="$H/.bashrc"

export PS1="\033[32m\w\033[1;35mL \033[0;30m"

alias v="$VIM/vim.exe"

fk() {
    case "$1" in
        v)  v $BASHRC   ;;
        s)  . $BASHRC   ;;
        vs) fk v; fk s  ;;
        *)  echo "fk: ForkKILLET"
    esac
}

csf() {
    for i in "$(ls *.$1)"; do
        mv $i "${i%.*}.$2"
    done
}



