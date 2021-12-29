#!/bin/zsh

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

			export MASNN="forkkillet@0.masnn.ml"
			export MHOME="$MASNN:/home/forkkillet"

			export BHJGIT="git@194.56.226.21"
			
w fkub &&	export JAVA_HOME="$H/app/Java/Contents/Home"
w fkar &&	export JAVA_HOME="/usr/lib/jvm/java-15-openjdk"
   
w fkub &&	export KOTLIN_HOME="$H/app/kotlinc"
   
w fkub &&	export GRADLE_HOME="$H/app/gradle"
w fkub &&	export GRADLE_USER_HOME="$H/.gradle"

w fkar &&	export CARGO_HOME="$H/.cargo/bin"
   
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

			export GITHUB="https://github.com"
w fkub &&	export GIT_BIN="$H/libexec/git-core"
w fkub &&	export GIT_RES="$H/share/git-core"
			export GITRC="$H/.gitconfig"
w fkub &&	export GIT_SSL_NO_VERIFY=1
			export GIT_EDITOR="vim"
   
w fkub ||
w x1tx &&	export XBQG_DATA="$H/res/xbqg"
w fkar &&	export XBQG_DATA="$H/.config/xbqg"

w x1tx &&	export MOLI_DATA="$H/res/www/0"

w fkub &&	export MANPATH="$H/share/man"

# :::: PATH

[ -z "$PATH_STATE" ] && {
	PATH_STATE="RESET"
	PATH_ORI="$PATH"
}
[ "$PATH_STATE" = "RESET" ] && {
	export PATH="$PATH_ORI:$H/bin:$NODE_PATH:$RVM_HOME:$JAVA_HOME:$KOTLIN_HOME/bin:$GRADLE_HOME:$GIT_BIN:$H/app/7-Zip:/$IDEA_HOME:$CARGO_HOME"
	PATH_STATE=UPDATED
}

# :::: PS1

PS1_SWITCH () {
	[ -n "$1" ] && PS1_STYLE=$1 || {
		[ "$PS1_STYLE" = LONG ] && PS1_STYLE=SHORT || PS1_STYLE=LONG
	}
	PS1="$(eval echo -e \$PS1_${1:-$PS1_STYLE}) "
}

w fkar &&	autoload -U colors && colors &&
			export PS1_LONG="%{$fg[green]%}%~ %{$fg_bold[magenta]%}Ψ%{$reset_color%}"	&& export PS1_SHORT="%{$fg_bold[magenta]%}Ψ%{$reset_color%}"
w fkub &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mΨ\[\033[0m"				&& export PS1_SHORT="\033[1;35mΨ\033[0m"
w msml &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mM\[\033[0m"				&& export PS1_SHORT="\033[1;35mM\033[0m"
w x1le &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mL\033[0m"		&& export PS1_SHORT="\033[1;35mL\033[0m"
w x1tx &&	export PS1_LONG="\033[32m\w\033[1;35mX\[\033[0m"							&& export PS1_SHORT="\033[1;35mX\033[0m"
w fkhw &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mΨ\033[0m"		&& export PS1_SHORT="\033[1;35mΨ\033[0m"
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

	CARGO_HOME			= $CARGO_HOME

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

ln() { # for windows
	[ $1 = -s ] && break
	cmd "/C mklink '$2' '$1'"$'\r\n'
}

cd_ () { cd "$H/_"; } # cd dash, cdda sh! 
cdbin () { cd "$H/bin/$1"; }
cddl () {
	w fkar && cd "$H/Downloads" || cd "$H/dl"
	w fkub && lsp
}
cdsrc () {
	[ "$1" = -m ] && {
		shift; local make=1
	}
	[ "$1" = -s ] && {
		shift; local server=1
	}
	local d
	case "$1" in 
		v)		d=vim									;;

		x)		d=xbqg									;;
		ml)		d=moli									;;

		n)		d=nodejs								;;
		nx)		d=nodejs/xbqg							;;
		tdb)	d=nodejs/TerminalDashboard				;;
		nu)		d=nodejs/Util							;;
		lh)		d=nodejs/Localhost						;;

		d)		d=nodejs/FkDice							;;

		gcis)	d=FkGitCommitInfoStd					;;

		h)		d=nodejs/Hydro							;;
		hb)		d=nodejs/Hydro/HydroBot					;;
		hu)		d=nodejs/Hydro/ui-default				;;

		nc)		d=nodejs/nodecpp						;;

		cg)		d=nodejs/golf							;;

		e)		d=electron								;;
		eq)		d=electron/electron-qq					;;

		il)		d=IceLava								;;
		it)		d=IceLava/Top							;	p=1628	;;
		ib)		d=IceLava/Bottom						;;
		id)		d=IceLava/Top/FkData					;;
		tpe)	d=IceLava/Top/TrainProblemEmulator		;;
		hwn)	d=IceLava/Top/HardWayNazo				;	p=1631	;;

		k)		d=kotlin								;;

		m)		d=mirai									;;

		a)		d=artcmds								;;
		c)		d=cpp									;;

		r)		d=rust									;;
		rs)		d=rust/study							;;

		pi)		d=piterator								;	p=1632	;;

		soap)	d=py/StackOverflowAnalyseProgram		;;

		u)		d=userscript							;;
		uw)		d=userscript/WhereIsMyForm				;;
		us)		d=userscript/SFAR						;;
		ue)		d=userscript/extend-luogu				;;
		ued)	d=userscript/extend-luogu/dashboard		;	p=1634	;;
		ut)		d=userscript/TM-dat						;	p=1633	;; 

		t)		d=typescript							;;
		tt)		d=typescript/test						;;
		
		*)		d="$1"									;;
	esac
	[ $make ] && mcd "$H/src/$d" || cd "$H/src/$d"
	[ $server ] && {
		[ -z $p ] && echo "Server not matched." || {
            xdg-open http://localhost:$p
            http-server -p $p
        }
	}
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

w fkar && alias xclipc="xclip -selection c"

psp () {
	ps | grep "$1" | grep -v "grep $1"
}

# :: APP

# :::: kotlin

alias gr="gradle"
alias grb="v build.gradle"

w fkar || w x1tx && {
	alias xbqg-go="c && xbqg ]"
	alias xbqg-go-less="c && xbqg -n ] | less"
}

ktc () {
	kotlinc z"$1.kt" -d "$1.jar"
	local classname="$(echo "${1:0:1}" | tr '[a-z]' '[A-Z]')${1:1}Kt"
	kotlin -classpath "$1.jar" "$classname"
}

# :::: nodejs

alias noded="node --unhandled-rejections=strict --trace-warnings"
alias nodei="node --inspect-brk=1629"

npm-s () {
	local s="$1"
	case "$1" in
		t | taobao) s="http://registry.npm.taobao.org/"	;;
		o | origin) s="http://registry.npmjs.org/"		;;
	esac
	npm config set registry "$s"
}

alias snowpack="yarn run snowpack"

# :::: shell

log () {
	case "$1" in
		-l | --list)
			ls "$H/log"
		;;
		-t | --traverse)
			shift
			local rev
			[ "$1" = -r ] && rev="-r"
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
				vim "$H/log/log-$(cdate $1)"
			else
				vim "$H/log/log-$1"
			fi
		;;
	esac
}

fk () {
	w fkar || w x1le || w x1tx && local f="$H/.zshrc" || local f="$H/.bashrc"
	case "$1" in
		s)	. $f					;;
		v)	v $f					;;
		vs) vs $f; w fkar && rehash	;;
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

w x1tx && . "$H/src/moli/moli.sh"

w fkar && proxy() {
	sudo systemctl start shadowsocks@bhj
}

# :::: git

alias g="git"

# :::: rust

alias C=cargo
w fkar && . "$H/.cargo/env"

# :::: vim

alias v="vim"
vn () { v "$1"; node "$1"; }
vnd () { v "$1"; noded "$1"; }
vni () { v "$1"; nodei "$1"; }
vr () { v "$1"; "$@"; }
vs () { v "$1"; . "$1"; }
vC () { v "$1"; C "$1"; }
ve () { v "$VIMRC"; }
vm () {
	[ -f main.js ] && v main.js
	[ -f src/main.js ] && v src/main.js
	[ -f src/main.ts ] && v src/main.ts
	[ -f src/main.rs ] && v src/main.rs
}

w x1tx && vh () { v "$1"; htm "$1"; }

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

w fkar && {

idea () {
	idea.sh > /dev/null 2> /dev/null &
	disown "%$(jobs | grep idea.sh | grep -oE '\[[0-9]+\]' | grep -oE '[0-9]+')"
}

url () {
	google-chrome-unstable $@
}

MC () {
	sudo /usr/bin/hmcl > /dev/null 2> /dev/null &
	disown "%$(jobs | grep sudo /usr/bin/hmcl | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
}

discord () {
	/opt/discord/Discord --proxy-server=socks5://127.0.0.1:1630 > /dev/null 2> /dev/null &
	disown "%$(jobs | grep /opt/discord/Discord | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
}

QQ () {
	/usr/bin/electron-qq > /dev/null 2> /dev/null &
	disown "%$(jobs | grep /usr/bin/electron-qq | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
}

alias o="xdg-open"

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

w fkar && {
	[ -f "$H/log/log-$today" -o "$TERM" = linux ] || {
		touch "$H/log/log-$today"
		proxy
		# fcitx -r > /dev/null 2> /dev/null &
	}
}

w msml && {
	echo -e "\033[1;35m今天也是美好的一天呢～赞美 masnn （）\033[0m"
}

