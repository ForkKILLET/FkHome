#!/usr/bin/env zsh
# vim: set fdm=marker:

# UTILS {{{

has-cmd () {
    which "$1" 2>&1 > /dev/null && return 0
    return 1
}

div () {
    echo "========================="
}

yesno () {
    local info
    [[ "$1" ]] && info="$1 "
    read -k1 "res?$info(y/n) "
    echo
    case "$res" in
        y)  return 0 ;;
        n)  return 1 ;;
        *)  return 2 ;;
    esac
}

print-exec () {
    echo \$ $@
    $@
}

# UTILS }}}

# ID {{{

touch ~/_/identity
ID=$(cat ~/_/identity)
ID=${ID:-temp}
case $ID in
    pide|piv2|fkte|fkni)
        ;;
    temp)
        echo "[dash] Temporary identity"
        ;;
    *)
        echo "[dash] Unknown identity $ID"
        return 1
esac

@ () {
    [[ $ID = $1 ]] && return 0
    return 1
}

# ID }}}

# PLACE {{{

## ENV {{{

            export PNPM_HOME="$HOME/.local/share/pnpm"
            export CARGO_HOME="$HOME/.cargo"

@ fkni &&   export ANDROID_HOME="$HOME/Android/Sdk"

            export VIMFILES="$HOME/.vim"
            export VIMRC="$VIMFILES/vimrc"

            export GPG_TTY=$(tty)

            export GITHUB="https://github.com"
            export GITRC="$HOME/.gitconfig"

@ fkni &&   export PROXY_HTTP="http://127.0.0.1:1643"
@ fkni &&   export PROXY_SOCKS5="socks5://127.0.0.1:1642"

@ fkni &&   export CELESTE="$HOME/.local/share/Steam/steamapps/common/Celeste"

## ENV }}}

## PATH {{{

[[ -z "$OLD_PATH" ]] && export OLD_PATH="$PATH"
export PATH="$OLD_PATH:$HOME/bin:$HOME/.local/bin:$JAVA_HOME/bin:$CARGO_HOME/bin:$PNPM_HOME:$AYA_PREFIX/bin:$HOME/bin/npm/bin"

## PATH }}}

## SERVER {{{

export  S_HK=112.213.124.196
export  S_HK2=202.146.216.180
export  S_GHP=https://ghproxy.com/

## SERVER }}}

# PLACE }}}

# ZSH {{{

setopt AUTO_CD
setopt EMACS
setopt EXTENDED_GLOB

autoload -U colors && colors
autoload -U compinit && compinit

## OH-MY-ZSH {{{

export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
plugins=(copypath fancy-ctrl-z gh fzf pip zsh-syntax-highlighting zsh-autosuggestions sudo rust extract httpie docker)
zstyle ':omz:plugins:yarn' berry yes
zstyle ':omz:plugins:yarn' aliases no
zstyle ':omz:plugins:git' aliases no
[[ -z "$NO_OMZ" && -d $ZSH ]] && source $ZSH/oh-my-zsh.sh

## OH-MY-ZSH }}}

## REHASH ON SIGUSR1 {{{

TRAPUSR1() { rehash }

## REHASH ON SIGUSR1 }}}

## PROMPT {{{

[[ $USER = root ]] && PS1_ROOT=' [root]'
export PS1_NORMAL="%F{167}[%D{%H:%M:%S}] %F{46}%~ %F{214}$ID %F{99}\$$PS1_ROOT%f "
export PS1="$PS1_NORMAL"

## PROMPT }}}

bindkey '\e[1;5C' forward-word      # ctrl right
bindkey '\e[1;5D' backward-word     # ctrl left

# ZSH }}}

# CLI CONFIG {{{

## HISTORY {{{

@ fkni &&   [[ $SHELL = /bin/zsh ]] && export HISTFILE="$HOME/Logs/hist"
            export HISTFILESIZE=10000000
            export HISTSIZE=10000000
            export SAVEHIST=$HISTSIZE

## HISTORY }}}

## EDTIOR {{{

export EDITOR="vim"
export GIT_EDITOR="vim"
export LESS="-Xr"

## EDTIOR }}}

# CLI CONFIG }}}

# CLI TOOLS SETUP {{{

has-cmd thefuck && eval "$(thefuck --alias)"
has-cmd fnm && eval "$(fnm env)"

export DIRENV_WARN_TIMEOUT=0s
has-cmd direnv && {
    eval "$(direnv hook zsh)"
}

# CLI TOOLS SETUP }}}

# CLI UNIFIED NAME {{{

has-cmd bat || alias bat=cat
has-cmd batcat && alias bat=batcat
bwhich () {
    which $1 | bat -l zsh
}
has-cmd proxychains5 && alias px="proxychains5 -q"
has-cmd proxychains4 && alias px="proxychains4 -q"

# CLI UNIFIED NAME }}}

# NIX {{{

@ fkni && {
    export NIXOS_CONFIG_DIR=~/_/nixos

    ne () {
        vim /etc/nixos/${1:-configuration}.nix
    }
    nec () {
        code -n $NIXOS_CONFIG_DIR
    }
    nb () {
        nh os switch $NIXOS_CONFIG_DIR $@
        rehash
    }
    nbp () {
        HTTP_PROXY="$PROXY_HTTP" HTTPS_PROXY="$PROXY_HTTP" nh os switch $NIXOS_CONFIG_DIR $@
        rehash
    }
    nbd () {
        local line=$((${1:-1} + 1))
        local id=$(echo /nix/var/nix/profiles/system-*-link | rg -o '\d+' | sort -nr | sed -n "${line}p")
        print-exec nix store diff-closures /nix/var/nix/profiles/system-${id}-link /var/run/current-system
    }
    nrf () {
        nix repl --expr "builtins.getFlake \"$PWD\""
    }
}

# NIX }}}

# CUSTOM COMMAND {{{

## TERM {{{

alias c=clear

c-256 () {
    for whatg in 38 48; do
        for color in {0..255}; do
            printf "\e[${whatg};5;%sm  %3s  \e[0m" $color $color
            [ $((($color + 1) % 6)) = 4 ] && echo
        done; echo
    done
}

c-ansi () {
    div
    echo "Foreground:"
    echo -n "| "
    echo "^[["{30..37}"m |"
    echo -n "| "
    echo -e "\033["{30..37}"mText\033[0m   |"
    div
    echo "Background:"
    echo -n "| "
    echo "^[["{40..47}"m |"
    echo -n "| "
    echo -e "\033["{40..47}"mText\033[0m   |"
    div
    echo "Foreground Style 1:"
    echo -n "| "
    echo "^[[1;3"{0..9}"m |"
    echo -n "| "
    echo -e "\033[1;3"{0..9}"mText\033[0m     |"
    div
    echo "Style:"
    echo -n "| "
    echo "^[["{0..9}"m |"
    echo -n "| "
    echo -e "\033["{0..9}"mText\033[0m  |"
    div
}

## TERM }}}

## FILE OPS {{{

cdd () {
    cd "$HOME/_/$1"
}
cdl () {
    cd "$HOME/Logs"
}

cddl () {
    @ fkni ||
    @ fkar && cd "$HOME/Downloads"
    @ fkte && cd "$HOME/downloads"
}


cdp () {
    cd ~/Projects/$1
}

compdef _cdp cdp
_cdp () {
    _files -/ -W ~/Projects
}

alias md="mkdir"
mcd () {
    mkdir -p "$1"
    cd "$1"
}

rmswp () {
    rm -f ${1:-.}/.*.swp
}
rmd () {
    mv "$1" "$HOME/rbin/$2"
}

has-cmd lsd && {
    alias l="lsd -A"
    alias ll="lsd -alh"
}

## FILE OPS }}}

## LOG {{{

log () {
    case "$1" in
        -l | --list)
            ls ~/Logs
        ;;
        -t | --traverse)
            shift
            local rev
            [[ $1 = -r || $1 = --reversed ]] && rev=-r
            for file in $(ls $rev ~/Logs); do
                div
                yesno "Bat <$file> ?" && {
                    div
                    bat -l markdown ~/Logs/$file
                }
            done
        ;;
        -r | --remove)
            shift
            yesno "Remove <$1>?" && {
                rm -f ~/Logs/$1
                echo "Removed <$1>."
            }
        ;;
        *)
            local cmd=vim
            local post=
            if [[ $1 = -b || $1 = --bat ]]; then
                shift
                cmd="bat -l markdown"
            elif [[ $1 = -c || $1 = --code  ]]; then
                shift
                cmd=code
            elif [[ $1 = -T || $1 == --typora ]]; then
                shift
                cmd='nohup typora'
                post=" > /dev/null 2>&1 &"
            fi
            local name="$1"
            if [[ $1 =~ ^[1-9][0-9]*$ ]]; then
                name="daily/$(date -d "$1 day ago" +%Y%m%d).md"
            elif [[ -z "$1" ]]; then
                name="daily/$(date +%Y%m%d).md"
            fi

            eval "$cmd $HOME/Logs/$name $post"
        ;;
    esac
}

compdef _log log
_log () {
    local files="files:_path_files -W $HOME/Logs -g '*'"
    local dft_files="*:$files"
    case "$state" in
        TRAVERSE) _arguments \
                {-r,--reverse}"[traverse in reverse order]::->END"
            ;;
        REMOVE) _arguments \
                {-f,--force}"[remove a log]" \
                "$dft_files"
            ;;
        "") _arguments \
                {-l,--list}"[list logs]::->END" \
                {-r,--remove}"[move a log to ~/rbin/+log]:option:->REMOVE" \
                {-t,--traverse}"[traverse all logs]:option:->TRAVERSE" \
                {-b,--bat}"[bat a log]:$files" \
                {-c,--code}"[open a log with Code]:$files" \
                {-T,--typora}"[open a log with Typora]:$files" \
                "$dft_files"
            ;;
    esac
}

## LOG }}}

## GIT {{{

alias g="git"

## GIT }}}

## YARN {{{

alias y="yarn"

## YARN }}}

## DOCKER {{{

alias dr="sudo systemctl daemon-reload && sudo systemctl restart docker"
alias d="sudo docker"
alias dc="sudo docker compose"

## DOCKER }}}

## VIM {{{

alias v="vim"
vr () {
    v "$1"
    "$@"
}
vs () {
    v "$1"
    source "$1"
}
ve () {
    v "$HOME/.vim/vimrc"
}

## VIM }}}

## CODE {{{

codew () {
    code ~/Projects/workspaces/$1
}
compdef _codew codew
_codew () {
    _files -W ~/Projects/workspaces
}

## CODE }}}

## FK {{{

,fk-init() {
    @ fkni ||
    @ fkar && {
        local today=$(date +%Y%m%d)
        local file=~/Logs/daily/$today.md
        [[ ! -e $file ]] && {
            echo '[dash] Creating log'
            touch $file
        }
    }
}

,fk-update () {
    echo '[dash] Updating dash...'
    cd $HOME/_
    git pull
}

fk () {
    local f="$HOME/.zshrc"
    case "$1" in
        u)  ,fk-update && fk s  ;;
        s)  . $f                ;;
        v)  v $f                ;;
        vs) fk v && fk s        ;;
        *)  echo "@ $ID"        ;;
    esac
}

## FK }}}

# CUSTOM COMMAND }}}

# DESKTOP {{{

## WINE {{{

export WINE=wine64
export WINEDEBUG=-all
export WINEPREFIX=~/.wine
alias wine32="WINEPREFIX=~/.wine32 WINEARCH=win32 wine64"
alias winetricks32="WINEPREFIX=~/.wine32 WINEARCH=win32 winetricks"

## WINE }}}

## IME CONFIG {{{

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

## IME CONFIG }}}

## CUSTOM COMMAND {{{

@ fkte && alias o="termux-open"
@ fkni ||
@ fkar && alias o="xdg-open"

has-cmd xclip && {
    xcopy () {
        cat - | xclip -selection c
    }
    xpaste() {
        xclip -selection c -o
    }
}

2fa () {
    local output="$(node ~/_/2fa $@)"
    has-cmd xcopy && {
        echo "$output" | grep -oP '(?<=<)\d{6}(?=>)' | xcopy
        echo "$output", copied to clipboard.
    } || {
        echo "$output"
    }
}
compdef _2fa 2fa
_2fa () {
    local files=($(ls ~/_/2fa/*.2fa | xargs -n1 basename -s .2fa))
    _values 2fa-files $files
}

has-cmd gdb && ,core-copy-latest () {
    if [[ -z "$EXE" ]]; then
        echo "missing \$EXE"
        return 1
    fi
    local exename=$(basename "$EXE")
    local file=$(ls /var/lib/systemd/coredump/core.$exename.* -t | head -n 1)
    if [ -n "$file" ]; then
        mkdir -p debug
        sudo cp "$file" ./debug
        echo "Copied latest core dump: $file"
        local basename=$(basename "$file")
        sudo chown $USER ./debug/$basename
        zstd -d ./debug/$basename
        echo "Decompressed core dump: ./debug/$(basename $basename .zst)"
        rm -f ./debug/$basename
    else
        echo "No core dumps found."
    fi
}

has-cmd gdb && ,core-debug-latest() {
    if [[ -z "$EXE" ]]; then
        echo "missing \$EXE"
        return 1
    fi
    local exename=$(basename "$EXE")
    local file=$(ls ./debug/core.$exename.* -t | head -n 1)
    if [ -n "$file" ]; then
        gdb $EXE "$file"
    else
        echo "No core dumps found in ./debug."
    fi
}

## CUSTOM COMMAND }}}

# DESKTOP }}}

# INIT {{{

,fk-init

precmd() {
    if [[ -n "$PROJECT" ]]; then
        PS1="%F{44}[$PROJECT] $PS1_NORMAL"
    else
        PS1="$PS1_NORMAL"
    fi
}

# INIT }}}
