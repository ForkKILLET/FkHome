# tmp, w = fklx
export HOME="/c/_"
export H=$HOME

export VIM="$H/vim"
export VIMRC="$H/.vimrc"
export BASHRC="$H/.bashrc"

export PS1="\033[32m\w\033[36m`__git_ps1` \033[1;35mL\033[0;30m "

alias v="$VIM/vim.exe"

c_ansi() {
	echo "\033[3"{0..7}"m"
	echo -e "\033[3"{0..7}"mText    "
}

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



