#!/bin/zsh
# vim: set fdm=marker :

# UTILS {{{

has-cmd () {
	which "$1" 2>&1 > /dev/null && return 0
	return 1
}

div () {
	echo "========================="
	return 0
}

yn () {
	local info
	[ "$1" ] && info="$1 "
	read -k1 "res?$info(y/n) "
	echo
	case "$res" in
		y)	return 0	;;
		n)	return 1	;;
		*)	return 2	;;
	esac
}

yn50 () {
	local info
	[ "$1" ] && info="$1 "
	read "res?$info(ye5/n0) "
	case "$res" in
		ye5)	return 0	;;
		n0)		return 1	;;
		*)		return 2	;;
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
	fkar|v.ps|fk10|fkos-xj|x1tx|xxer|pihc|fkni)
		;;
	temp)
		echo "[dash] Temporary identity"
		;;
	*)
		echo "[dash] Unknown identity @ $ID"
		return 1
esac

@ () {
	[ "$ID" = "$1" ] && return 0
	return 1
}

# ID }}}

# PLACE {{{

## ENV {{{

			export H="$HOME"

@ xxer &&	export LD_LIBRARY_PATH=/data/data/com.termux/files/usr/lib/openssl-1.1

@ fkar &&	export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
			export PNPM_HOME="$H/.local/share/pnpm"
			export CARGO_HOME="$H/.cargo"
@ fkar &&	export AYA_PREFIX="/opt/aya"

@ fkni &&	export ANDROID_HOME="$H/Android/Sdk"

			export VIMFILES="$H/.vim"
			export VIMRC="$VIMFILES/vimrc"

			export GPG_TTY=$(tty)

			export GITHUB="https://github.com"
			export GITRC="$H/.gitconfig"

@ fkar &&	export XBQG_DATA="$H/.config/xbqg"

@ fkni &&	export PROXY_HTTP="http://127.0.0.1:1643"
@ fkni &&	export PROXY_SOCKS5="socks5://127.0.0.1:1642"

@ fkni ||
@ fkar &&	export CELESTE="$H/.local/share/Steam/steamapps/common/Celeste"
@ fkni ||
@ fkar &&	export CelestePrefix="$CELESTE"

@ fkar &&	[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

## ENV }}}

## PATH {{{

[[ -z "$FK_PATH" ]] && {
	FK_PATH=RESET
	PATH_ORI="$PATH"
}
[[ "$FK_PATH" = RESET ]] && {
	export PATH="$PATH_ORI:$H/bin:$H/.local/bin:$JAVA_HOME/bin:$CARGO_HOME/bin:$PNPM_HOME:$AYA_PREFIX/bin"
	FK_PATH=UPDATED
}

## PATH }}}

## SERVER {{{

export	S_HK=112.213.124.196
export	S_HK2=202.146.216.180
export	S_GHP=https://ghproxy.com/

## SERVER }}}

# PLACE }}}

# ZSH {{{

setopt AUTO_CD
setopt EMACS
setopt EXTENDED_GLOB

## OH-MY-ZSH {{{

export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
plugins=(copypath fancy-ctrl-z gh fzf pip zsh-syntax-highlighting sudo pm2 rust extract httpie yarn)
[[ -z "$NO_OMZ" && -d $ZSH ]] && source $ZSH/oh-my-zsh.sh
zstyle ':omz:plugins:yarn' berry yes

## OH-MY-ZSH }}}

## REHASH ON SIGUSR1 {{{

TRAPUSR1() { rehash }

## REHASH ON SIGUSR1 }}}

## PROMPT {{{

autoload -U colors && colors
[[ $USER = root ]] && PS1_ROOT=' [root]'
export PS1_NORMAL="%F{167}[%D{%H:%M:%S}] %F{46}%~ %F{214}$ID %F{99}Ψ$PS1_ROOT%f "
export PS1_SHORT="%F{167}[%D{%H:%M:%S}] %F{214}$ID %F{99}Ψ$PS1_ROOT%f "
prompt () {
	case $1 in
		n|normal)	export PS1="$PS1_NORMAL"	;;
		s|short)	export PS1="$PS1_SHORT"		;;
		*)			return 1					;;
	esac
	return 0
}
prompt normal

## PROMPT }}}

bindkey '\e[1;5C' forward-word		# ctrl right
bindkey '\e[1;5D' backward-word		# ctrl left

# ZSH }}}

# CLI CONFIG {{{

## HISTORY {{{

@ fkni ||
@ fkar &&	[[ $SHELL = /bin/zsh ]] && export HISTFILE="$H/log/log-hist"
			[[ $SHELL = /bin/bash ]] && export HISTFILE="$H/log/log-hist-bash"
			export HISTFILESIZE=1000000
			export HISTSIZE=1000000
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
has-cmd opam && eval "$(opam env)"
has-cmd adbunch && eval "$(QU=1 adbunch gencomp)"

has-cmd rustc && has-cmd compdef && compdef __comp_cargo cargo
__comp_cargo() {
	source "$(rustc --print sysroot)"/share/zsh/site-functions/_cargo
}

[[ -f ~/.config/broot/launcher/bash/br ]] && source ~/.config/broot/launcher/bash/br || true

[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && source ~/.config/tabtab/zsh/__tabtab.zsh || true

# CLI TOOLS SETUP }}}

# CLI UNIFIED NAME {{{

@ fk10 && alias bat=batcat
has-cmd bat || alias bat=cat
@ fkar && alias px="proxychains5 -q"
@ fkni && alias px="proxychains4 -q"
@ fkni && alias sudopx="sudo proxychains4 -q"

# CLI UNIFIED NAME }}}

# NIX {{

@ fkni && {
	ne () {
		vim /etc/nixos/configuration.nix
	}
	nec () {
		code -n ~/_/nixos
	}
	nb () {
		sudo nixos-rebuild switch $@
		rehash
	}
	nbp () {
		sudo env ALL_PROXY=${PROXY_HTTP} HTTP_PROXY=${PROXY_HTTP} HTTPS_PROXY=${PROXY_HTTP} nixos-rebuild switch $@
		rehash
	}
	nbd () {
		local line=$((${1:-1} + 1))
		local id=$(echo /nix/var/nix/profiles/system-*-link | rg -o '\d+' | sort -nr | sed -n "${line}p")
		print-exec nix store diff-closures /nix/var/nix/profiles/system-${id}-link /var/run/current-system
	}
}

# NIX }}

# CUSTOM COMMAND {{{

alias plz=sudo
alias c=clear

gohome () {
	~/_/gohome.sh
	return 0
}

## FORKKILLET {{{

fk () {
	local f="$H/.zshrc"
	case "$1" in
		u)	cd $H/_; git pull; fk s		;;
		s)	. $f						;;
		v)	vim $f						;;
		vs) vs $f; @ fkar && rehash		;;
		S)	FK_PATH=RESET; fk s			;;
		vS) FK_PATH=RESET; fk vs		;;
		i)	FK_INIT=INIT; fk s			;;

		*)	echo "@ $ID"
	esac
	return 0
}

## FORKKILLET }}}

## CHECK {{{

c-256 () {
	for whatg in 38 48; do
		for color in {0..255}; do
			printf "\e[${whatg};5;%sm  %3s	\e[0m" $color $color
			[ $((($color + 1) % 6)) = 4 ] && echo
		done; echo
	done
	return 0
}

c-csi () {
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
	return 0
}

c-env ()
{
	div -s
	echo "
ID                  = $ID
PATH                = \`
$PATH
\`

HOME                = $HOME

VIM                 = $VIM
VIMRC               = $VIMRC

CARGO_HOME          = $CARGO_HOME

XBQG_DATA           = $XBQG_DATA

PS1                 = $PS1

HISTFILE            = $HISTFILE
HISTFILESIZE        = $HISTFILESIZE
SAVEHIST            = $SAVEHIST
"
	div -s
}

## CHECK }}}

## FILE OPS {{{

cdd () {
	cd "$H/_/$1";
	return 0
}
cdl () {
	cd "$H/log"
	return 0
}
cdb () {
	cd "$H/bin/$1"
	return 0
}
cddl () {
	@ fkni ||
	@ fkar && cd "$H/Downloads"
	@ x1tx && cd "$H/downloads"
	return 0
}

rnnp () { # ReName: No Parens
	local name="$(echo "$1" | sed -e 's/ *([0-9]*)//g')"
	mv "$1" "$name"
	echo "rnnp: $1 -> $name"
	return 0
}

### CDS {{{

cds () {
	[ "$1" = -m ] && {
		shift; local make=1
	}
	[ "$1" = -c ] && {
		shift; local vscode=1
	}
	[ "$1" = -s ] && {
		shift; local server=1
	}
	[ "$1" = -S ] && {
		shift; local server=2
	}
	local d
	local p
	case "$1" in
		v)		d=vim									;;

		adb)	d=adbunch								;;

		x)		d=xbqg									;;

		ce)		d=celeste								;;
		cef)	d=celeste/ForkKILLETHelper				;;

		cs)		d=csharp								;;
		csl)	d=csharp/learn							;;

		n)		d=nodejs								;;

		sc)		d=nodejs/SwitchyConfig					;;
		nl)		d=nodejs/learn							;;
		wb)		d=willbot								;;
		wbl)	d=willbot-legacy						;;

		il)		d=IceLava								;;
		it)		d=IceLava/Top							;	p=1628						;;
		mt)		d=IceLava/Top/MazeTest					;	p=1635						;;
		ib)		d=IceLava/Bottom						;;
		id)		d=IceLava/Top/FkData					;;
		tpe)	d=IceLava/Top/TrolleyProblemEmulator	;	p=1636/docs/?debug=1		;;
		tped)	d=IceLava/Top/TrolleyProblemEmulator	;	p=1636/docs/debug?debug=1	;;
		hwn)	d=IceLava/Top/HardWayNazo				;	p=1631						;;
		jc)		d=IceLava/Top/JCer						;;

		nd)		d=NyaDict								;;

		som)	d=IceLava/Top/SudoerOfMyself			;	p=1637/docs					;;
		somos)	d=IceLava/Top/SudoerOfMyself/SOMOS		;;

		c)		d=cpp									;;

		r)		d=rust									;;
		rs)		d=rust/switchy							;;
		rl)		d=rust/learn							;;
		rp)		d=rust/pow-logic						;;

		pi)		d=piterator								;;
		ps)		d=piterator/pisearch					;;
		pob)	d=piterator/oierspace-cli-bag			;;

		soap)	d=py/StackOverflowAnalyseProgram		;;

		u)		d=userscript							;;
		ua)		d=userscript/all						;;
		uw)		d=userscript/WhereIsMyForm				;;
		us)		d=userscript/SFAR						;;
		ue)		d=userscript/extend-luogu				;;
		ues)	d=userscript/exlg-setting-new			;	p=1634						;;
		ut)		d=userscript/TM-dat						;	p=1633/test.html			;;
		up)		d=userscript/pkhh						;;

		t)		d=typescript							;;
		tt)		d=typescript/test						;;

		rel)	d=react/learn							;;

		p)		d=prolog								;;
		hl)		d=haskell/learn							;;

		*)		d="$1"									;;
	esac
	[ $make ] && mcd "$H/src/$d" || cd "$H/src/$d"
	[ $vscode ] && code -r .
	[ $server ] && {
		[ -z $p ] && echo "Server not defined." || {
			local url="http://localhost:$p"
			echo "$url"
			case "$server" in
				1) http-server --cors -p ${p%%/*} -o ${p##*/} &
				;;
			esac
		}
	}
	return 0
}

has-cmd compdef && compdef __comp_cds cds
__comp_cds () {
	local sources=($(which cds | grep -o '([^*]*)' | tr -d '()'))
	_values $sources
}

### CDS }}}

alias md="mkdir"
mcd () {
	mkdir -p "$1"
	cd "$1"
	return 0
}

alias rm='rm -i'
rmswp () {
	rm -f ${1:-.}/.*.swp
	return 0
}
rmd () {
	mv "$1" "$H/.trash/$2"
	return 0
}

has-cmd lsd && {
	alias l="lsd -a"
	alias ll="lsd -alh"
}

## FILE OPS }}}

## LOG {{{

log () {
	case "$1" in
		-l | --list)
			ls ~/log
		;;
		-t | --traverse)
			shift
			local rev
			[[ $1 = -r || $1 = --reversed ]] && rev=-r
			for file in $(ls $rev ~/log | rg log-); do
				div -s
				yn "Bat <$file> ?" && {
					div -s;
					bat -l markdown ~/log/$file
				}
			done
		;;
		-r | --remove)
			shift
			if [[ $1 = -f || $1 = --force ]]; then
				shift
				yn50 "Remove <$1> forever?" && {
					rm -f ~/log/$1
					echo "Removed <$1> permanently."
				}
			else
				yn "Remove <$1> ?" && {
					mkdir -p ~/rbin/+log
					rmd ~/log/$1 +log
					echo "Moved <$1> to <~/rbin/+log>."
				}
			fi
		;;
		*)
			local cmd=vim
			if [[ $1 = -b || $1 = --bat ]]; then
				shift
				cmd="bat -l markdown"
			elif [[ $1 = -c || $1 = --code  ]]; then
				shift
				cmd=code
			fi

			local name="$1"
			if [[ $1 =~ ^[0-9]+$ ]]; then
				name="log-$(date -d "$1 day ago" +%Y%m%d)"
			elif [[ -z "$1" ]]; then
				name="log-$(date +%Y%m%d)"
			fi

			eval "$cmd $H/log/$name"
		;;
	esac
	return 0
}
has-cmd compdef && compdef __comp_log log
__comp_log () {
	local files="files:_path_files -W $H/log -g 'log-*'"
	local dft_files="*:$files"
	case "$state" in
		TRAVERSE) _arguments \
				{-r,--reverse}"[traverse in reverse order]::->END"
			;;
		REMOVE) _arguments \
				{-f,--force}"[remove a log]" \
				"$dft_files"
			;;
		"")	_arguments \
				{-l,--list}"[list logs]::->END" \
				{-r,--remove}"[move a log to ~/rbin/+log]:option:->REMOVE" \
				{-t,--traverse}"[traverse all logs]:option:->TRAVERSE" \
				{-b,--bat}"[bat a log]:$files" \
				{-c,--code}"[open a log with Code]:$files" \
				"$dft_files"
			;;
	esac
}

## LOG }}}

## GIT {{{

alias g="git"

## GIT }}}

## VIM {{{

alias v="vim"
vr () {
	v "$1"
	"$@"
	return 0
}
vs () {
	v "$1"
	source "$1"
	return 0
}
ve () {
	v "$H/.vim/vimrc"
	return 0
}

## VIM }}}

## HOST {{{

host-ban () {
	sudo sed -i "1i\\0.0.0.0 $1" /etc/hosts
	return 0
}
host-unban () {
	return 1
}

## HOST }}}

# CUSTOM COMMAND }}}

# DESKTOP {{{

## WINE {{{

export WINEDEBUG=-all

export WINEPREFIX=~/.wine
alias wine32="WINEPREFIX=~/.wine32 WINEARCH=win32 wine"
alias winetricks32="WINEPREFIX=~/.wine32 WINEARCH=win32 winetricks"

## WINE }}}

## X11 IN WSL {{{

@ fk10 && {
	displayx () {
		export DISPLAY=`sudo grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
		return 0
	}
	startx () {
		vcxsrv -ac -terminate -lesspointer -multiwindow -clipboard -wgl 2>&1 > /dev/null &
		return 0
	}
}

## X11 IN WSL }}}

## IME CONFIG {{{

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

## IME CONFIG }}}

## CUSTOM COMMAND {{{

@ x1tx && alias o="termux-open"
@ fkni ||
@ fkar && alias o="xdg-open"
@ fk10 && alias o="wslview"

has-cmd xclip && {
	xcopy () {
		echo $@ | xclip -selection c
		return 0
	}
}

2fa () {
	local output="$(node ~/_/2fa)"
	has-cmd xclip && {
		echo "$output" | awk '{print $2}' | xclip -selection c
		echo "$output", copied to clipboard.
	} || {
		echo "$output"
	}
}

has-cmd xdg-icon-resource && has-cmd icotool && has-cmd awk && xicoinstall () {
	local file=${1:t:r}
	local name=${2:-${file}}
	echo "- icon name \"${name}\""
	echo "> icotool -l \"$1\""
	icotool -l "$1"
	md -p /tmp/xicoinstall
	echo "> icotool -x \"$1\" -o /tmp/xicoinstall"
	icotool -x "$1" -o /tmp/xicoinstall
	local installsh="$(icotool -l "$1" | awk -F '[ =]' "{print \"xdg-icon-resource install --size \" \$5 \" /tmp/xicoinstall/${file}_\" \$3 \"_\" \$5 \"x\" \$7 \"x\" \$9 \".png ${name}\"}")"
	echo "$installsh" | xargs -L1 echo '>'
	echo "$installsh" | bash
}

## CUSTOM COMMAND }}}

# DESKTOP }}}

# INIT {{{

@ fkni ||
@ fkar && {
	local today=$(date +%Y%m%d)
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		FK_INIT=

		echo '[dash] Creating log'
		touch "$H/log/log-$today"

		echo '[dash] Updating dash'
		fk u
	}
}

@ fk10 && {
	has-cmd vcxsrv && setup_vcxsrv () {
		echo '[dash] Starting vcxsrv'
		export DISPLAY=$(sudo cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
		return 0
	}

	local today=$(date +%Y%m%d)
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		FK_INIT=

		echo '[dash] Creating log'
		touch "$H/log/log-$today"

		# write_host
	}
}

# INIT }}}
