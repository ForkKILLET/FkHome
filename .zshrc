#!/bin/bash

# :: ENV

# :: WHERE

case "$HOME" in
	/home)
		export WHERE="fkar"	;;
	/var/root)
		export WHERE="fkub"	;;
	/home/forkkillet)
		export WHERE="msml"	;;
	/home|/data/data/com.termux/files/home)
		export WHERE="x1tx"	;;
	/c/_|/c/Users/lenovo)
		export WHERE="x1le"	;;
	/c/home|/c/Users/ForkKILLET)
		export WHERE="fkhw" 	;;
	*)
		echo "Unknown device @ $HOME."
		return 1
esac

w () {
	[ "$WHERE" = "$1" ] && return 0
	return 1
}

# :::: PLACES

w fkub &&	export HOME="/Volumes/FORKUB/Safety"
w x1le &&	export HOME="/c/_"
w fkhw &&	export HOME="/c/home"
			export H="$HOME"

w fkub &&	export RUIN="/Volumes/FORKUB/Backups.backupdb/MacBook Pro/Latest/"

			export MASNN="forkkillet@0.masnn.ml"
			export MHOME="$MASNN:/home/forkkillet"

			export BHJGIT="git@194.56.226.21"
			
w fkub &&	export JAVA_HOME="$H/app/Java/Contents/Home"
   
w fkub &&	export KOTLIN_HOME="$H/app/kotlinc"
   
w fkub &&	export GRADLE_HOME="$H/app/gradle"
w fkub &&	export GRADLE_USER_HOME="$H/.gradle"
   
w fkub &&	export RVM_HOME="$H/src/rvm"
   
w fkub &&	export NPM_G="$H/lib/node_modules"
w fkub &&	export NODE_PATH="$NPM_G"
w x1le ||
w fkhw &&	export NODE_PATH="$H/app/nodejs"

w x1le ||
w fkub &&	export VIM="$H/app/vim"
w x1tx &&	export VIMRUNTIME="$H/../usr/share/vim/vim82"
			export VIMRC="$H/.vim/vimrc"
			export VIM_VUDDLE="$H/bundle"
   
w fkub &&	export GIT_BIN="$H/libexec/git-core"
w fkub &&	export GIT_RES="$H/share/git-core"
			export GITRC="$H/.gitconfig"
w fkub &&	export GIT_SSL_NO_VERIFY=1
   
w fkub ||
w x1tx &&	export XBQG_DATA="$H/res/xbqg"

w x1tx &&	export MOLI_DATA="$H/res/www/0"

w fkub &&	export MANPATH="$H/share/man"

# :::: PATH

[ -z "$PATH_STATE" ] && {
	PATH_STATE="RESET"
	PATH_ORI="$PATH"
}
[ "$PATH_STATE" = "RESET" ] && {
	export PATH="$PATH_ORI:$H/bin:$NODE_PATH:$RVM_HOME:$JAVA_HOME:$KOTLIN_HOME/bin:$GRADLE_HOME:$GIT_BIN:$H/app/7-Zip"
	PATH_STATE=UPDATED
}

# :::: PS1

PS1_SWITCH () {
	[ -n "$1" ] && PS1_STYLE=$1 || {
		[ "$PS1_STYLE" = LONG ] && PS1_STYLE=SHORT || PS1_STYLE=LONG
	}
	PS1="$(eval echo -e \$PS1_${1:-$PS1_STYLE}) "
}

w fkar &&	export PS1_LONG="%{$fg[green]%}%~ %{$fg_bold[magenta]%}Ψ%{$reset_color%}"	&& export PS1_SHORT="%F{magenta}Ψ%f"
w fkub &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mΨ\[\033[0m"			&& export PS1_SHORT="\033[1;35mΨ\033[0m"
w msml &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mM\[\033[0m"			&& export PS1_SHORT="\033[1;35mM\033[0m"
w x1le &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mL\033[0m"	&& export PS1_SHORT="\033[1;35mL\033[0m"
w x1tx &&	export PS1_LONG="\033[32m\w\033[1;35mX\[\033[0m"						&& export PS1_SHORT="\033[1;35mX\033[0m"
w fkhw &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mΨ\033[0m"	&& export PS1_SHORT="\033[1;35mΨ\033[0m"
			PS1_SWITCH LONG

w fkub &&	export HISTFILE="$H/log/log-hist"
w x1tx &&	export HISTFILE="$H/.bash_history"
			export HISTFILESIZE=1919810
			export HISTSIZE=1919810

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
	local res info;
	[ "$1" ] && info="$1 ";
	read -p "$info(y/n) " -n 1 res;
	echo
	case "$res" in
		y)	return 0	;;
		n)	return 1	;;
		*)	return 2	;;
	esac
}

yn50 () {
	local res info;
	[ "$1" ] && info="$1 ";
	read -ep "$info(ye5/n0) " res;
	case "$res" in
		ye5)	return 0	;;
		n0)	 return 1		;;
		*)	  return 2		;;
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

c_ansi () { 
	div
	echo "Color:"
	echo -n "| "
	echo "^["{30..37}"m |"
	echo -n "| "
	echo -e "\033["{30..37}"mText\033[0m  |"
	div
	echo "Style:"
	echo -n "| "
	echo "^["{0..13}"; |"
	echo -n "| "
	echo -e "\033["{0..13}";30mText\033[0m |"
	div
}

c_env () 
{ 
	div -s;
	echo "
	WHERE				= $WHERE
	PATH				= \`
$PATH
'

	HOME				= $HOME
	
	VIM					= $VIM
	VIMRC				= $VIMRC
	VIM_VUDDLE			= $VIM_VUDDLE
	
	MASNN				= $MASNN
	MHOME				= $MHOME

	RVM_HOME			= $RVM_HOME

	NPM_G				= $NPM_G
	NODE_PATH			= $NODE_PATH

	XBQG_DATA			= $XBQG_DATA

	JAVA_HOME			= $JAVA_HOME
	KOTLIN_HOME			= $KOTLIN_HOME
	GRADLE_HOME			= $GRADLE_HOME
	GRADLE_USER_HOME	= $GRADLE_USER_HOME

	PS1					= $PS1

	HISTFILE			= $HISTFILE
	HISTFILESIZE		= $HISTFILESIZE
";
	div -s
}

# :: FILE

alias ..="cd .."
alias ...="cd ../.."

cdbin () { cd "$H/bin/$1"; }
cddl () { cd "$H/dl"; lsp; }
cdsrc () { 
	local p
	case "$1" in 
		v)		p=vim							;;

		x)		p=xbqg							;;
		m)		p=moli							;;

		n)		p=nodejs						;;
		nx)		p=nodejs/xbqg					;;
		tdb)	p=nodejs/TerminalDashboard		;;
		nu)		p=nodejs/Util					;;
		lh)		p=nodejs/Localhost				;;
		hb)		p=nodejs/HydroBot				;;
		nc)		p=nodejs/nodecpp				;;

		k)		p=kotlin						;;
		md)		p=kotlin/MiraiDemo/mirai-demos	;;

		a)		p=artcmds						;;
		c)		p=cpp							;;

		r)		p=rust							;;
		rs)		p=rust/study					;;

		hwn)	p=IceLava/HardWayNazo			;;
		it)		p=IceLava/Top					;;
		ib)		p=IceLava/Btm					;;

		u)		p=userscript					;;
		uw)		p=userscript/WhereIsMyForm		;;
		us)		p=userscript/SFAR				;;
		
		*)		p="$1"							;;
	esac
	cd "$H/src/$p"
}
w fkub && cdruin () { cd "$RUIN"; PS1_SWITCH SHORT; }

alias md="mkdir"
mcd () {
	mkdir -p "$1"
	cd "$1"
}

alias rm='rm -i'
rmswp () {
	rm -f ${1:-.}/.*.sw{o,p}
}
rmd () {
	mv "$1" "$H/rbin/$2"
}

lsp () {
	case "$(pwd)" in
		"$H/dl")
			local res=$(ls)
			res=${res//.wait/ \[\\033\[36mwait\\033\[0m]}
			res=${res//.process/ \[\\033\[35mprocess\\033\[0m]}
			res=${res//.fail/ \[\\033\[31mfail\\033\[0m]}
			res=${res//.succeed/ \[\\033\[32msucceed\\033\[0m]}
			echo -e "$res"
		;;
	esac
}

csf () {
	for i in $(ls *.$1); do
		mv $i "${i%%.*}.$2"
	done
}

w fkub || alias l="ls -a --color"
w msml && export LS_COLORS="di=4:fi=1:ln=35;4:or=35;5:mi=35;2:ex=36;1:*.msg=34"

w fkub ||
w x1le ||
w msml &&
tree () {
	find "${1:-.}" -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'
}

# :::: ELSE

w fkub && {
	alias zip='tar -Zcvf'
	alias unzip='tar -Zxvf'
}

w x1tx ||
w fkhw ||
w msml ||
w fkar && alias c=clear

psp () {
	ps | grep "$1" | grep -v "grep $1"
}

# :: APP

# :::: kotlin

alias gr="gradle"
alias grb="v build.gradle"

w x1tx && {
	alias xbqg="node $H/src/xbqg/main.js"
	alias xbqg-go="c;xbqg fn"
}

ktc () {
	kotlinc z"$1.kt" -d "$1.jar"
	local classname="$(echo "${1:0:1}" | tr '[a-z]' '[A-Z]')${1:1}Kt"
	kotlin -classpath "$1.jar" "$classname"
}

# :::: nodejs

alias noded="node --unhandled-rejections=strict --trace-warnings"
alias nodei="node --inspect"

npm-s () {
	local s="$1"
	case "$1" in
		t | taobao) s="http://registry.npm.taobao.org/"	;;
		o | origin) s="http://registry.npmjs.org/"		;;
	esac
	npm config set registry "$s"
}

# :::: shell

dotpath () {
	local path
	if [ $1 = "-e" ]; then
		path="echo "
		shift
	fi
	if [ ${1:0:1} = "/" ]; then
		path="$path$@"
	else
		path="$path./$@"
	fi
	$path
}

log () {
	case "$1" in
		-l | --list)
			ls "$H/log"
		;;
		-t | --travel)
			local list
			case "$2" in
				r | reverse)	list=$(ls -r $/log) ;;
				o | order | *)	list=$(ls $/log)	;;
			esac
			for file in $list; do
				div -s
				yn "Cat <$file> ?" && {
					div -s;
					cat "$H/log/$file"
				}
			done
		;;
		-r | --remove)
			shift
			yn "Remove <log-$1> ?" && {
				mkdir -p "$H/rbin/+log"
				rmd "$H/log/log-$1" "+log"
				echo "You can find it at <~/rbin/+log>."
			}
		;;
		-rf | --remove-forever)
			shift
			yn50 "Remove <log-$1> forever?" && {
				rm -f "$H/log/log-$1"
				echo "You can never find it."
			}
		;;
		*)
			if [[ $1 =~ ^[+-][0-9]+$ || -z "$1" ]]; then
				v "$H/log/log-$(cdate $1)"
			else
				v "$H/log/log-$1"
			fi
		;;
	esac
}

fk () {
	w fkar && local f="$H/.zshrc" || local f="$H/.bashrc"
	case "$1" in
		s)	. $f					;;
		v)	v $f					;;
		vs) vs $f					;;
		S)	PATH_STATE=RESET; . $f	;;
		vS) PATH_STATE=RESET; vs $f	;;
		*)	w fkub || w fkar && echo "fk: ForkKILLET" || "fk: not at home"
	esac
}

hi () {
	case "$1" in
		c)	cat $HISTFILE	;;
		v)	v $HISTFILE		;;
		*)	history "$@"	;;
	esac
}

w x1tx && source "$H/src/moli/moli.sh"

# :::: git

alias g="git"

# :::: rust

alias C=cargo

# :::: vim

alias v="vim"
vn () { v "$1"; node "$1"; }
vnd () { v "$1"; noded "$1"; }
vr () { v "$1"; dotpath "$@"; }
vs () { v "$1"; . "$1"; }
ve () { v "$VIMRC"; }

w x1tx && vh () { v "$1"; htm "$1"; }

# :: DESKTOP

w fkar && export GDK_NATIVE_WINDOWS=true

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

w x1tx && {

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

# :: WORK

-- () {
	case "$1" in
		tdb | t)
			noded "$H/src/nodejs/TerminalDashboard/dashboard.js"
		;;
		xbqg | x)
			noded "$H/src/nodejs/xbqg/main.js" $@
		;;
		hwn | h)
			shift
			case "$1" in
				s | server)
					cdsrc hwn
					c
					node "$H/src/IceLava/HardWayNazo/dep/server.js"
				;;
				d | develop)
					cdsrc hwn
					PS1_SWITCH
					c
				;;
			esac
		;;
		*)
			echo "--: no such task \"$1\""
		;;
	esac
}

## :: SERVER

## :::: masnn

alias M="ssh $MASNN"

w msml && mm () {
	if [ -z "$1" ]; then
		cat "$H/msg"
	else
		case "$1" in
			-d)
				echo "-----===$2===-----" >> "$H/msg"
			;;
			-c)
				read -p "(ye5/n0) " opt
				case "$opt" in
					ye5)	echo > "$H/msg"					;;
					n0)		echo "OK, calm down."			;;
					*)		echo "I can't understand you."	;;
				esac
			;;
			-v)
				v "$H/msg"
			;;
			*)
				echo "$1" >> "$H/msg"
		esac
	fi
}

# :: INIT

today=$(cdate)

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

w fkar && {
	[ -f "$H/log/log-$today" ] || {
		touch "$H/log/log-$today"

		fcitx -r > /dev/null 2> /dev/null &
	}
}

w msml && {
	echo -e "\033[1;35m今天也是美好的一天呢～赞美 masnn （）\033[0m"
}

