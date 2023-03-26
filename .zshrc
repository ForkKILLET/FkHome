#!/bin/zsh
# vim: set fdm=marker :

# UTILS {{{

has-cmd () {
	which "$1" 2>&1 > /dev/null && return 0
	return 1
}

div () {
	echo "========================="
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

# UTILS }}}

# WHERE {{{

case "$HOST" in
	fkar)
		export WHERE="fkar"	;;
	be.icelava.top)
		export WHERE="fkhk"	;;
	DESKTOP-LHTMB71)
		export WHERE="fk10"	;;
	localhost)
		export WHERE="x1tx"	;;
	*)
		echo "Unknown device @ $HOST."
		return 1
esac

@ () {
	[ "$WHERE" = "$1" ] && return 0
	return 1
}

# WHERE }}}

# PLACE {{{

## ENV {{{

			export H="$HOME"

@ fkar &&	export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
			export PNPM_HOME="$H/.local/share/pnpm"
			export CARGO_HOME="$H/.cargo"

			export VIMFILES="$H/.vim"
			export VIMRC="$VIMFILES/vimrc"
@ fkar &&	if [[ $(($(date +%H) < 15)) ]]; then
				export VIMBG=light
			else
				export VIMBG=dark
			fi

			export GITHUB="https://github.com"
			export GITRC="$H/.gitconfig"

@ fkar &&	export XBQG_DATA="$H/.config/xbqg"

@ fkar &&	export CELESTE="$H/.local/share/Steam/steamapps/common/Celeste"

@ fkar &&	[[ -f "$CARGO_HOME/env" ]] && source "$CARGO_HOME/env"

## ENV }}}

## PATH {{{

[[ -z "$FK_PATH" ]] && {
	FK_PATH=RESET
	PATH_ORI="$PATH"
}
[[ "$FK_PATH" = RESET ]] && {
	export PATH="$PATH_ORI:$H/bin:$H/.local/bin:$JAVA_HOME/bin:$CARGO_HOME/bin:$PNPM_HOME"
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

## OH-MY-ZSH {{{

export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
plugins=(copypath fancy-ctrl-z gh fzf ripgrep fnm pip zsh-syntax-highlighting sudo pm2 rust extract)
[[ -z "$NO_OMZ" && -d $ZSH ]] && source $ZSH/oh-my-zsh.sh

## OH-MY-ZSH }}}

## REHASH ON SIGUSR1 {{{

TRAPUSR1() { rehash }

## REHASH ON SIGUSR1 }}}

## PROMPT {{{

autoload -U colors && colors
export PS1_NORMAL="%F{167}[%D{%H:%M:%S}] %F{46}%~ %F{214}$WHERE %F{99}Ψ%f "
export PS1_SHORT="%F{167}[%D{%H:%M:%S}] %F{214}$WHERE %F{99}Ψ%f "
prompt () {
	case $1 in
		n|normal)	export PS1="$PS1_NORMAL"	;;
		s|short)	export PS1="$PS1_SHORT"		;;
	esac
}
prompt normal

## PROMPT }}}

# ZSH }}}

# CLI CONFIG {{{

## HISTORY {{{

@ fkar &&	export HISTFILE="$H/log/log-hist"
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

[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && source ~/.config/tabtab/zsh/__tabtab.zsh || true
[[ -f /usr/share/nvm/init-nvm.sh ]] && source /usr/share/nvm/init-nvm.sh

# CLI TOOLS SETUP }}}

# CLI UNIFIED NAME {{

@ fk10 && alias bat=batcat

# CLI UNIFIED NAME }}

# CUSTOM COMMAND {{{

alias plz="sudo"
alias c="clear"
alias gohome="$H/_/gohome.sh"

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

		*)	echo "@ $WHERE"
	esac
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
}

c-env ()
{
	div -s
	echo "
WHERE               = $WHERE
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

cdd () { cd "$H/_"; } # cd dash, cdda sh!
cddv () { cd "$H/_/FkVim"; }
cdl () { cd "$H/log"; }
cdb () { cd "$H/bin/$1"; }
cddl () {
	@ fkar && cd "$H/Downloads"
	@ x1tx && cd "$H/downloads"
}

### CDS {{{

cds () {
	[ "$1" = -m ] && {
		shift; local make=1
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
		ml)		d=moli									;;

		n)		d=nodejs								;;

		sc)		d=nodejs/SwitchyConfig					;;
		nl)		d=nodejs/learn							;;
		wb)		d=nodejs/Willbot						;;
		wbb)	d=nodejs/Willbot/beta					;;
		nx)		d=nodejs/xbqg							;;
		tdb)	d=nodejs/TerminalDashboard				;;
		nu)		d=nodejs/fkutil							;;
		lh)		d=nodejs/l627							;;
		cp)		d=nodejs/cuiping						;;

		i2)		d=nodejs/Icalingua2						;;
		i3)		d=nodejs/Icalingua3						;;

		gt)		d=FkGitTest								;;
		gcms)	d=FkGitCommitMsgStd						;;

		h)		d=nodejs/Hydro							;;
		hb)		d=nodejs/Hydro/HydroBot					;;
		hu)		d=nodejs/Hydro/ui-default				;;
		hh)		d=nodejs/Hydro/Hydro					;;
		hm)		d=nodejs/Hydro/mongo.js					;;

		nc)		d=nodejs/nodecpp						;;
		np)		d=nodejs/pow-logic						;;

		cg)		d=nodejs/golf							;;

		rstt)	d=nodejs/rSTTranslator					;;

		e)		d=electron								;;
		eq)		d=electron/electron-qq					;;

		il)		d=IceLava								;;
		it)		d=IceLava/Top							;	p=1628						;;
		mt)		d=IceLava/Top/MazeTest					;	p=1635						;;
		ib)		d=IceLava/Bottom						;;
		id)		d=IceLava/Top/FkData					;;
		tpe)	d=IceLava/Top/TrolleyProblemEmulator	;	p=1636/docs/?debug=1		;;
		tped)	d=IceLava/Top/TrolleyProblemEmulator	;	p=1636/docs/debug?debug=1	;;
		hwn)	d=IceLava/Top/HardWayNazo				;	p=1631						;;
		jc)		d=IceLava/Top/JCer						;;

		som)	d=IceLava/Top/SudoerOfMyself			;	p=1637/docs					;;
		some)	d=IceLava/Top/SudoerOfMyself/src/ext0_file_system	;;
		somos)	d=IceLava/Top/SudoerOfMyself/SOMOS		;;

		k)		d=kotlin								;;

		m)		d=mirai									;;

		a)		d=artcmds								;;
		c)		d=cpp									;;

		r)		d=rust									;;
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
}

alias rm='rm -i'
rmswp () {
	rm -f ${1:-.}/.*.swp
}
rmd () {
	mv "$1" "$H/.trash/$2"
}

@ x1tx ||
@ fkhk ||
@ fk10 ||
@ fkar && {
	alias l="lsd -a"
	alias ll="lsd -alh"
}

## FILE OPS }}}

## LOG {{{

log () {
	case "$1" in
		-l | --list)
			ls "$H/log"
		;;
		-t | --traverse)
			shift
			local rev
			[[ "$1" = -r || "$1" = --reversed ]] && rev="-r"
			for file in $(ls $rev "$H/log"); do
				div -s
				yn "Cat <$file> ?" && {
					div -s;
					cat "$H/log/$file"
				}
			done
		;;
		-r | --remove)
			shift
			if [[ "$1" = -f || "$1" = --force ]]; then
				shift
				yn50 "Remove <$1> forever?" && {
					rm -f "$H/log/$1"
					echo "You can never find it."
				}
			else
				yn "Remove <$1> ?" && {
					mkdir -p "$H/rbin/+log"
					rmd "$H/log/$1" "+log"
					echo "You can find it at <~/rbin/+log>."
				}
			fi
		;;
		*)
			local sudo
			if [[ "$1" = -s || "$1" = --sudo ]]; then
				shift
				sudo="sudo -E "
			fi

			local cmd=vim
			local back
			if [[ "$1" = -c || "$1" = --cat ]]; then
				shift
				cmd=cat
			elif [[ "$1" = -T || "$1" = --typora ]]; then
				shift
				cmd=typora
				back=" &"
			elif [[ "$1" = -w || "$1" = --wsl ]]; then
				shift
				cmd=wslview
			fi

			local name="$1"
			if [[ $1 =~ ^[+-][0-9]+$ || -z "$1" ]]; then
				name="log-$(date +%Y%m%d)" # TODO fix cdate
			fi

			eval "$sudo$cmd \"$H/log/$name\"$back"
		;;
	esac
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
		SUDO) _arguments \
				{-c,--cat}"[cat a log]:$files" \
				{-T,--typora}"[open a log with Typora]:$files" \
				{-w,--wsl}"[open a log in WSL]:$files" \
				"$dft_files"
			;;
		"")	_arguments \
				{-l,--list}"[list logs]::->END" \
				{-r,--remove}"[move a log to ~/rbin/+log]:option:->REMOVE" \
				{-t,--traverse}"[traverse all logs]:option:->TRAVERSE" \
				{-c,--cat}"[cat a log]:$files" \
				{-T,--typora}"[open a log with Typora]:$files" \
				{-w,--wsl}"[open a log in WSL]:$files" \
				{-s,--sudo}"[run with sudo]:mode:->SUDO" \
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
vn () { v "$1"; node "$1"; }
vnd () { v "$1"; noded "$1"; }
vni () { v "$1"; nodei "$1"; }
vr () { v "$1"; "$@"; }
vs () { v "$1"; . "$1"; }
ve () { v "$H/.vim/vimrc"; }
vm () {
	[ -f main.js ] && v main.js
	[ -f src/main.js ] && v src/main.js
	[ -f src/main.ts ] && v src/main.ts
	[ -f src/main.rs ] && v src/main.rs
}
vpl () { v "$H/.plrc" }

## VIM }}}

## HOST {{{

host-ban () {
	sudo sed -i "1\\0.0.0.0 $1" "$H/log/log-hosts"
}
host-unban () {
	return 1
}

## HOST }}}

# CUSTOM COMMAND }}}

# DESKTOP {{{

## X11 IN WSL {{{

@ fk10 && {
	export DISPLAY=`grep -oP "(?<=nameserver ).+" /etc/resolv.conf`:0.0
	startx () {
		vcxsrv -ac -terminate -lesspointer -multiwindow -clipboard -wgl 2>&1 > /dev/null &
	}
}

## X11 IN WSL }}}

@ fkar && {
	wemeet-restart-with-chat () {
		if [ -d ~/app/chat.bak ]; then
			sudo mv ~/app/chat.bak /opt/wemeet/bin/modules/chat
		fi
		killall /opt/wemeet/bin/wemeetapp
		wemeet 2>&1 > /dev/null &
	}
	wemeet-restart-without-chat () {
		if [ -d /opt/wemeet/bin/modules/chat ]; then
			sudo mv /opt/wemeet/bin/modules/chat ~/app/chat.bak
		fi
		killall /opt/wemeet/bin/wemeetapp
		wemeet 2>&1 > /dev/null &
	}
	wemeet-restart () {
		killall /opt/wemeet/bin/wemeetapp
		wemeet 2>&1 > /dev/null &
	}
}

## IME CONFIG {{{

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx

## IME CONFIG }}}

## X11 CUSTOM COMMAND {{{

@ x1tx && alias o="termux-open"
@ fkar && alias o="xdg-open"
@ fk10 && alias o="wslview"

has-cmd xclip && {
	xcopy () {
		xclip -selection c "$1"
	}

	xcwd () {
		pwd | xcopy
	}
}

## X11 CUSTOM COMMAND }}}

# DESKTOP }}}

# INIT {{{

@ fkar && {
	local today=$(date +%Y%m%d)
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		FK_INIT=

		echo '[dash] Creating log'
		touch "$H/log/log-$today"
	}
}

@ fk10 && {
	if has-cmd vcxsrv && [[ "$(ps -C vcxsrv --no-header | wc -l)" = 0 ]]; then
		# echo '[dash] Starting vcxsrv'
	fi

	function write_host () {
		echo '[dash] Writing host'
		sudo tee <<<"$S_HK2 v2.piterator.com" -a /etc/hosts > /dev/null
	}

	local today=$(date +%Y%m%d)
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		FK_INIT=

		echo '[dash] Creating log'
		touch "$H/log/log-$today"

		write_host
	}
}

# INIT }}}
