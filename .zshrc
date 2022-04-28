#!/bin/zsh

# :: ENV

# :: WHERE

case "$HOME" in
	/home)
		export WHERE="fkar"	;;
	/var/root)
		export WHERE="fkub"	;;
	/home|/data/data/com.termux/files/home)
		export WHERE="xxtx"	;;
	/c/_|/c/Users/lenovo)
		export WHERE="x1le"	;;
	/c/home|/c/Users/ForkKILLET)
		export WHERE="fkhw" ;;
	*)
		echo "Unknown device @ $HOME."
		return 1
esac

w () {
	[ "$WHERE" = "$1" ] && return 0
	return 1
}

alias gohome="zsh $H/_/gohome.sh"

# :::: PLACES

w fkub &&	export HOME="/Volumes/FORKUB/Safety"
w x1le &&	export HOME="/c/_"
w fkhw &&	export HOME="/c/home"
			export H="$HOME"
			export FK="$HOME"

w fkub &&	export RUIN="/Volumes/FORKUB/Backups.backupdb/MacBook Pro/Latest/"

w fkub &&	export JAVA_HOME="$H/app/Java/Contents/Home"
w fkar &&	export JAVA_HOME="/usr/lib/jvm/java-16-openjdk"
   
w fkub &&	export KOTLIN_HOME="$H/app/kotlinc"
   
w fkub &&	export GRADLE_HOME="$H/app/gradle"
w fkub &&	export GRADLE_USER_HOME="$H/.gradle"

w fkar &&	export CARGO_HOME="$H/.cargo"
   
w fkub &&	export RVM_HOME="$H/src/rvm"
   
w fkub &&	export NPM_G="$H/lib/node_modules"
w fkub &&	export NODE_PATH="$NPM_G"
w x1le ||
w fkhw &&	export NODE_PATH="$H/app/nodejs"

w x1le ||
w fkub &&	export VIM="$H/app/vim"
w fkar &&	export VIMFILES="$H/.vim" &&
			export VIMRC="$VIMFILES/vimrc"
w xxtx &&	export VIMRUNTIME="$H/../usr/share/vim/vim82"

			export GITHUB="https://github.com"
w fkub &&	export GIT_BIN="$H/libexec/git-core"
w fkub &&	export GIT_RES="$H/share/git-core"
			export GITRC="$H/.gitconfig"
w fkub &&	export GIT_SSL_NO_VERIFY=1
			export GIT_EDITOR="vim"
   
w fkub ||
w xxtx &&	export XBQG_DATA="$H/res/xbqg"
w fkar &&	export XBQG_DATA="$H/.config/xbqg"

w xxtx &&	export MOLI_DATA="$H/res/www/0"

w fkar ||
w fkub &&	export MANPATH="/usr/share/man"

w fkar &&	export BROWSER_DEV="firefox"
w fkar &&	export EDITOR="vim"

			export BAIDU_FANYI_APPID=20200920000569502
			export BAIDU_FANYI_SECRET=59ejpZc1QWPoaVrssd5c

# :::: PATH

[ -z "$FK_PATH" ] && {
	FK_PATH="RESET"
	PATH_ORI="$PATH"
}
[ "$FK_PATH" = "RESET" ] && {
	export PATH="$PATH_ORI:$H/bin:$H/local/.bin:$NODE_PATH:$RVM_HOME:$JAVA_HOME/bin:$KOTLIN_HOME/bin:$GRADLE_HOME:$GIT_BIN:$H/app/7-Zip:/$IDEA_HOME:$CARGO_HOME/bin"
	FK_PATH=UPDATED
}

# :::: ZSH

export ZSH="$HOME/.oh-my-zsh"
setopt AUTO_CD
# setopt VI
ZSH_DISABLE_COMPFIX=true
plugins=(copypath thefuck yarn fancy-ctrl-z gh fzf ripgrep fnm pip)
[ -z "$NO_OMZ" ] && source $ZSH/oh-my-zsh.sh

eval "$(thefuck --alias)"
eval "$(fnm env --use-on-cd)"
eval "$(opam env)"

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

w fkar ||
w fkub &&	export HISTFILE="$H/log/log-hist"
w xxtx &&	export HISTFILE="$H/.bash_history"
			export HISTFILESIZE=1000000
			export HISTSIZE=1000000
			export SAVEHIST=$HISTSIZE

# :::: fcitx

w fkar && {
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
	div -s;
	echo "
WHERE               = $WHERE
PATH                = \`
$PATH
'

HOME                = $HOME

VIM                 = $VIM
VIMRC               = $VIMRC
VIM_VUDDLE          = $VIM_VUDDLE

MASNN               = $MASNN
MHOME               = $MHOME

RVM_HOME            = $RVM_HOME

NPM_G               = $NPM_G
NODE_PATH           = $NODE_PATH

CARGO_HOME          = $CARGO_HOME

XBQG_DATA           = $XBQG_DATA

JAVA_HOME           = $JAVA_HOME
KOTLIN_HOME         = $KOTLIN_HOME
GRADLE_HOME         = $GRADLE_HOME
GRADLE_USER_HOME    = $GRADLE_USER_HOME

PS1                 = $PS1

HISTFILE            = $HISTFILE
HISTFILESIZE        = $HISTFILESIZE
SAVEHIST            = $SAVEHIST
";
	div -s
}

# :: FILE

cdd () { cd "$H/_"; } # cd dash, cdda sh! 
cddv () { cd "$H/_/FkVim"; }
cdb () { cd "$H/bin/$1"; }
cddl () {
	w fkar && cd "$H/Downloads"
	w fkub && cd "$H/dl"
	w fkub && lsp
}
w fkub && cdruin () { cd "$RUIN"; PS1_SWITCH SHORT; }

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
		wb)		d=nodejs/WillBot								;;
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
compdef __comp_cds cds
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

w fkar && {
	alias l="lsd"
	alias ll="lsd -lh"
}

w fkub || w x1le &&
tree () {
	find "${1:-.}" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

export LESS="-Xr"

# :::: ELSE

w fkub && {
	zip() { tar -Zcvf }
	unzip() { tar -Zxvf }
}

w xxtx ||
w fkhw ||
w fkar && alias c=clear

w fkar && {
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

w fkar && {
	pacman-re-S () {
		pacman -Qs "$1"	\
		| grep local	\
		| xargs node -e \
		'
		console.log(process
			.argv
			.slice(1)
			.filter((_, k) => k % 2 === 0)
			.map(s => s.split("/")[1])
			.join("\n")
		)
		' \
		| xargs sudo pacman -S --noconfirm
	}
}

# :::: kotlin

w fkar || w xxtx && {
	alias xbqg-go="c && xbqg ]"
	alias xbqg-go-less="c && xbqg -n ] | less"
}

ktc () {
	kotlinc z"$1.kt" -d "$1.jar"
	local classname="$(echo "${1:0:1}" | tr '[a-z]' '[A-Z]')${1:1}Kt"
	kotlin -classpath "$1.jar" "$classname"
}

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
				name="log-$(cdate $1)"
			fi
			
			zsh -c "$sudo$cmd \"$H/log/$name\"$back"
		;;
	esac
}
compdef __comp_log log
__comp_log () {
	local __comp_file="*:files:_path_files -W $H/log"
	case "$state" in
		TRAVERSE) _arguments \
				{-r,--reverse}"[traverse in reverse order]::->END"
			;;
		REMOVE) _arguments \
				{-f,--force}"[remove a log]" \
				"$__comp_file"
			;;
		SUDO) _arguments \
				{-c,--cat}"[cat a log]:files:_path_files -W $H/log" \
				{-T,--typora}"[open a log with Typora]:files:_path_files -W $H/log" \
				"$__comp_file"
			;;
		"")	_arguments \
				{-l,--list}"[list logs]::->END" \
				{-r,--remove}"[move a log to ~/rbin/+log]:option:->REMOVE" \
				{-t,--traverse}"[traverse all logs]:option:->TRAVERSE" \
				{-c,--cat}"[cat a log]:files:_path_files -W $H/log" \
				{-T,--typora}"[open a log with Typora]:files:_path_files -W $H/log" \
				{-s,--sudo}"[run with sudo]:mode:->SUDO" \
				"$__comp_file"
			;;
	esac
}

fk () {
	local f="$H/.zshrc"
	case "$1" in
		s)	. $f						;;
		v)	v $f						;;
		vs) vs $f; w fkar && rehash		;;
		S)	FK_PATH=RESET; fk s			;;
		vS) FK_PATH=RESET; fk vs		;;
		i)	FK_INIT=INIT; fk s			;;
		
		*)	w fkub || w fkar && echo "$WHERE: at home" || "$WHERE: not at home"
	esac
}

w xxtx && . "$H/src/moli/moli.sh"

# :::: git

alias g="git"

# :::: rust

w fkar && . "$H/.cargo/env"

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

w xxtx && vh () { v "$1"; htm "$1"; }

# :: DESKTOP

w fkub && {
	safari () {
		case "$1" in 
			-h | -home)
				defaults write com.apple.Safari HomePage "$2"
			;;
			*)
				"$H/app/Safari/Contents/MacOS/Safari" > /dev/null 2> /dev/null &
				disown "%$(jobs | grep Contents/MacOS/Safari | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
			;;
		esac
	}

	nw () {
		echo "$@" > "$H/.new_terminal_rc"
		"/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"\
		> /dev/null 2> /dev/null &
		disown "%$(jobs | grep Contents/MacOS/Terminal | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
	}
}

w xxtx && {
	img () {
		termux-open "$1" --content-type=image/${1:-jpeg}
	}
	url () {
		local u="$1"
		termux-open-url "$u"
	}

	htm () {
		termux-open "$1" --content-type=text/html
	}

	share () {
		termux-open "$1" --send
	}
}

w fkar && {
	alias o="xdg-open"
}

## :::: Minecraft

w fkar && {
	alias hmcl="echo Don\\'t play Minecraft!"
	unalias hmcl

	export MINECRAFT="$H/.config/hmcl/.minecraft"
	export MINECRAFT_ASSETS="$MINECRAFT/versions/1.16.5/1.16.5.jar.unzip/assets/minecraft"
	export MINECRAFT_RES_CELESTE="$MINECRAFT/resourcepacks/Celeste"
}

## :::: Celeste

w fkar && {
	export CELESTE="$H/.local/share/Steam/steamapps/common/Celeste"
}

## :: SERVER

# :: INIT

w fkub && today=$(cdate) || today=$(date +%Y%m%d)

w fkub && {
	[ -f "$H/log/log-$today" ] || {
		touch "$H/log/log-$today"

		safari -h "http://localhost:1627"
		safari
 
		c_env
		echo -e "\033[1;35m今天也是美好的一天呢～不要颓废哦\033[0m"
		cd "$H"
	}
	[ "$(psp node\ /Volumes/FORKUB/Safety/src/nodejs/Localhost/server.js)" ] || {
		node "$H/src/nodejs/Localhost/server.js" >> "$H/log/log-l627" 2>> "$H/log/log-l627" &
	}
}

w msml && {
	echo -e "\033[1;35m今天也是美好的一天呢～赞美 masnn （）\033[0m"
}

w fkar && {
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		echo "I'm ForkKILLET"
		touch "$H/log/log-$today"
		log -T log-olclass # Online class
		FK_INIT=
	}
}
