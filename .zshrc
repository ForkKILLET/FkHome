#!/bin/zsh

# :: ENV

# :::: WHERE

case "$HOST" in
	fkar)
		export WHERE="fkar"	;;
	ecs-j3uOh)
		export WHERE="fkhk"	;;
	*)
		echo "Unknown device @ $HOME."
		return 1
esac

@ () {
	[ "$WHERE" = "$1" ] && return 0
	return 1
}

has-cmd () {
	which "$1" 2>&1 > /dev/null && return 0
	return 1
}

# :::: PLACES
			export H="$HOME"

@ fkar &&	export JAVA_HOME="/usr/lib/jvm/java-8-openjdk"
   
			export CARGO_HOME="$H/.cargo"
   
			export VIMFILES="$H/.vim"
			export VIMRC="$VIMFILES/vimrc"

			export GITHUB="https://github.com"
			export GITRC="$H/.gitconfig"
			export GIT_EDITOR="vim"
   
@ fkar &&	export XBQG_DATA="$H/.config/xbqg"

@ fkar &&	export BROWSER_DEV="firefox"
@ fkar &&	export EDITOR="vim"

# :::: PATH

[[ -z "$FK_PATH" ]] && {
	FK_PATH="RESET"
	PATH_ORI="$PATH"
}
[[ "$FK_PATH" = RESET ]] && {
	export PATH="$PATH_ORI:$H/bin:$H/local/.bin:$NODE_PATH:$JAVA_HOME/bin:$CARGO_HOME/bin"
	FK_PATH=UPDATED
}

# :::: ZSH

setopt AUTO_CD
setopt EMACS

export ZSH="$HOME/.oh-my-zsh"
ZSH_DISABLE_COMPFIX=true
plugins=(copypath thefuck yarn fancy-ctrl-z gh fzf ripgrep fnm pip)
[[ -z "$NO_OMZ" && -d $ZSH ]] && source $ZSH/oh-my-zsh.sh

# :::: CLI TOOLS SETUP

has-cmd thefuck && eval "$(thefuck --alias)"
has-cmd fnm && eval "$(fnm env)"
has-cmd opam && eval "$(opam env)"

# :::: PS1

PS1_SWITCH () {
	[ -n "$1" ] && PS1_STYLE=$1 || {
		[ "$PS1_STYLE" = LONG ] && PS1_STYLE=SHORT || PS1_STYLE=LONG
	}
	PS1="$(eval echo -e \$PS1_${1:-$PS1_STYLE}) "
}

autoload -U colors && colors
export PS1_LONG="%F{167}[%D{%H:%M:%S}] %F{46}%~ %F{214}$WHERE %F{99}Ψ%f "
export PS1_SHORT="%F{214}$WHERE %F{99}Ψ%f "
export PS1="$PS1_LONG"

@ fkar &&	export HISTFILE="$H/log/log-hist"
			export HISTFILESIZE=1000000
			export HISTSIZE=1000000
			export SAVEHIST=$HISTSIZE

# :::: fcitx

@ fkar && {
	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS=@im=fcitx
}

# :: UTIL

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

# :: CHECK

c_256 () { 
	for whatg in 38 48; do
		for color in {0..255}; do
			printf "\e[${whatg};5;%sm  %3s	\e[0m" $color $color;
			[ $((($color + 1) % 6)) = 4 ] && echo
		done; echo
	done
}

c_csi () { 
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

c_env () 
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

# :: FILE

cdd () { cd "$H/_"; } # cd dash, cdda sh! 
cddv () { cd "$H/_/FkVim"; }
cdb () { cd "$H/bin/$1"; }
cddl () {
	@ fkar && cd "$H/Downloads"
}

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
		# ::::	SRC BEGIN
		v)		d=vim									;;

		x)		d=xbqg									;;
		ml)		d=moli									;;

		n)		d=nodejs								;;
		wb)		d=nodejs/Willbot						;;
		wbb)	d=nodejs/Willbot/beta					;;
		nx)		d=nodejs/xbqg							;;
		tdb)	d=nodejs/TerminalDashboard				;;
		nu)		d=nodejs/fkutil							;;
		lh)		d=nodejs/l627							;;

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
		uw)		d=userscript/WhereIsMyForm				;;
		us)		d=userscript/SFAR						;;
		ue)		d=userscript/extend-luogu				;;
		ues)	d=userscript/exlg-setting-new			;	p=1634						;;
		ut)		d=userscript/TM-dat						;	p=1633/test.html			;;
		up)		d=userscript/pkhh						;;

		t)		d=typescript							;;
		tt)		d=typescript/test						;;

		p)		d=prolog								;;
		hl)		d=haskell/learn							;;
		# ::::	SRC END
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
	local sources=($(which cds | rg --color=never --pcre2 '(?<=\()[^*]+(?=\) d=)' -o))
	_values $sources
}

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
	mv "$1" "$H/rbin/$2"
}

@ fkhk ||
@ fkar && {
	alias l="lsd"
	alias ll="lsd -lh"
}

export LESS="-Xr"

# :::: ELSE

@ fkar && {
	xcopy() {
		xclip -selection c "$1"
	}
	xcwd () {
		pwd | xcopy
	}
}

psp () {
	ps aux | grep "$1" | grep -v "grep $1"
}

# :: APP

# :::: nodejs

noded() {
	node --unhandled-rejections=strict --trace-warnings "$1"
}
nodei() {
	node --inspect-brk=1629 "$1"
}

npm-taobao() { npm set registry https://registry.npm.taobao.org/ }
npm-origin() { npm set registry https://registry.npmjs.org/ }

# :::: shell

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
			fi

			local name="$1"
			if [[ $1 =~ ^[+-][0-9]+$ || -z "$1" ]]; then
				name="log-$(date +%Y%m%d)" # TODO fix cdate
			fi
			
			zsh -c "$sudo$cmd \"$H/log/$name\"$back"
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
				"$dft_files"
			;;
		"")	_arguments \
				{-l,--list}"[list logs]::->END" \
				{-r,--remove}"[move a log to ~/rbin/+log]:option:->REMOVE" \
				{-t,--traverse}"[traverse all logs]:option:->TRAVERSE" \
				{-c,--cat}"[cat a log]:$files" \
				{-T,--typora}"[open a log with Typora]:$files" \
				{-s,--sudo}"[run with sudo]:mode:->SUDO" \
				"$dft_files"
			;;
	esac
}

fk () {
	local f="$H/.zshrc"
	case "$1" in
		s)	. $f						;;
		v)	v $f						;;
		vs) vs $f; @ fkar && rehash		;;
		S)	FK_PATH=RESET; fk s			;;
		vS) FK_PATH=RESET; fk vs		;;
		i)	FK_INIT=INIT; fk s			;;
		
		*)	echo "@ $WHERE"
	esac
}

@ xxtx && . "$H/src/moli/moli.sh"

# :::: git

alias g="git"

# :::: rust

@ fkar && . "$H/.cargo/env"

# :::: vim

alias v="/usr/bin/vim"
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

host-ban () {
	sudo sed -i "1\\0.0.0.0 $1" "$H/log/log-hosts"
}
host-unban () {
	echo "No way."
}

# :: DESKTOP

alias o="xdg-open"

@ fkar && {
	export CELESTE="$H/.local/share/Steam/steamapps/common/Celeste"
}

## :: SERVER

# :: INIT

@ fkar && {
	local today=$(date +%Y%m%d)
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		echo "I'm ForkKILLET"
		touch "$H/log/log-$today"
		log -T log-olclass # Online class
		FK_INIT=
	}
}
