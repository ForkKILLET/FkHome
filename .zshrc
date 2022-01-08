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

			export MASNN="forkkillet@0.masnn.ml"
			export MHOME="$MASNN:/home/forkkillet"

			export BHJGIT="git@194.56.226.21"
			
w fkub &&	export JAVA_HOME="$H/app/Java/Contents/Home"
w fkar &&	export JAVA_HOME="/usr/lib/jvm/java-16-openjdk"
   
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
w xxtx &&	export VIMRUNTIME="$H/../usr/share/vim/vim82"
			export VIMFILES="$H/.vim"
			export VIMRC="$VIMFILES/vimrc"

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

w fkub &&	export MANPATH="$H/share/man"

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
	export PATH="$PATH_ORI:$H/bin:$NODE_PATH:$RVM_HOME:$JAVA_HOME/bin:$KOTLIN_HOME/bin:$GRADLE_HOME:$GIT_BIN:$H/app/7-Zip:/$IDEA_HOME:$CARGO_HOME"
	FK_PATH=UPDATED
}

# :::: ZSH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(copypath thefuck yarn fancy-ctrl-z gh)

[ -z "$NO_OMZ" ] && source $ZSH/oh-my-zsh.sh

eval $(thefuck --alias)

# :::: PS1

PS1_SWITCH () {
	[ -n "$1" ] && PS1_STYLE=$1 || {
		[ "$PS1_STYLE" = LONG ] && PS1_STYLE=SHORT || PS1_STYLE=LONG
	}
	PS1="$(eval echo -e \$PS1_${1:-$PS1_STYLE}) "
}

w fkar &&	autoload -U colors && colors &&
			export PS1_LONG="%{$fg[green]%}%~ %{$fg_bold[magenta]%}Ψ%{$reset_color%}"	&& export PS1_SHORT="%{$fg_bold[magenta]%}Ψ%{$reset_color%}" &&
			export RPS1="%{$fg_bold[red]%}%?%{$reset_color%}"
w fkub &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mΨ\[\033[0m"				&& export PS1_SHORT="\033[1;35mΨ\033[0m"
w msml &&	export PS1_LONG="\033[1;34m\u\033[0;32m\w\033[1;35mM\[\033[0m"				&& export PS1_SHORT="\033[1;35mM\033[0m"
w x1le &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mL\033[0m"		&& export PS1_SHORT="\033[1;35mL\033[0m"
w xxtx &&	export PS1_LONG="\033[32m\w\033[1;35mX\[\033[0m"							&& export PS1_SHORT="\033[1;35mX\033[0m"
w fkhw &&	export PS1_LONG="\033[32m\w\033[36m\`__git_ps1\` \033[1;35mΨ\033[0m"		&& export PS1_SHORT="\033[1;35mΨ\033[0m"
			PS1_SWITCH LONG

w fkar ||
w fkub &&	export HISTFILE="$H/log/log-hist"
w xxtx &&	export HISTFILE="$H/.bash_history"
			export HISTFILESIZE=1000000
			export HISTSIZE=1000000
			export SAVEHIST=$HISTSIZE

# :::: ZSH

w fkar && {
	setopt AUTO_CD
}

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
cdb () { cd "$H/bin/$1"; }
cddl () {
	w fkar && cd "$H/Downloads"
	w fkub && cd "$H/dl"
	w fkub && lsp
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
		wb)		d=nodejs/WillBot						;;
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

		k)		d=kotlin								;;

		m)		d=mirai									;;

		a)		d=artcmds								;;
		c)		d=cpp									;;

		r)		d=rust									;;
		rl)		d=rust/learn							;;
		rp)		d=rust/pow-logic						;;

		pi)		d=piterator								;;

		soap)	d=py/StackOverflowAnalyseProgram		;;

		u)		d=userscript							;;
		uw)		d=userscript/WhereIsMyForm				;;
		us)		d=userscript/SFAR						;;
		ue)		d=userscript/extend-luogu				;;
		ues)	d=userscript/exlg-setting-new			;	p=1634						;;
		ut)		d=userscript/TM-dat						;	p=1633/test.html			;; 

		t)		d=typescript							;;
		tt)		d=typescript/test						;;

		p)		d=prolog								;;
		# ::::	SRC END
		*)		d="$1"									;;
	esac
	[ $make ] && mcd "$H/src/$d" || cd "$H/src/$d"
	[ $server ] && {
		[ -z $p ] && echo "Server not defined." || {
			local url="http://localhost:$p"
			echo "$url"
            case "$server" in
				1)	http-server -p ${p%%/*} &
				;;
				2)	nohup http-server -p ${p%%/*} &
				;;
			esac
			echo "Opening <$url> with $BROWSER_DEV"
            $BROWSER_DEV "$url"
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

w fkub || alias l="ls -A --color"
w msml && export LS_COLORS="di=4:fi=1:ln=35;4:or=35;5:mi=35;2:ex=36:*.msg=35"
w fkar && export LS_COLORS="$LS_COLORS:*.idea=35"

w fkub || w x1le || w msml &&
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
w msml ||
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
			local cmd=vim
			if [[ "$1" = -c || "$1" = --cat ]]; then
				shift
				cmd=cat
			fi
			if [[ "$1" = -s || "$1" = --sudo ]]; then
				shift
				cmd="sudo -E $cmd"
			fi

			local name="$1"
			if [[ $1 =~ ^[+-][0-9]+$ || -z "$1" ]]; then
				name="$(cdate $1)"
			fi
			
			zsh -c "$cmd $H/log/log-$name"
		;;
	esac
}

fk () {
	w fkar || w x1le || w xxtx && local f="$H/.zshrc" || local f="$H/.bashrc"
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

hi () {
	case "$1" in
		c)	cat $HISTFILE	;;
		v)	v $HISTFILE		;;
		*)	history "$@"	;;
	esac
}

w xxtx && . "$H/src/moli/moli.sh"

# :::: git

alias g="git"

# :::: rust

alias C=cargo
w fkar && . "$H/.cargo/env"

# :::: vim

alias v="/usr/bin/vim"
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
vpl () { v "$H/.plrc" }

host-ban () {
	echo "0.0.0.0\t\t\t\t$1" | sudo tee -a /etc/hosts
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

idea () {
	nohup idea.sh &
	disown
}

webstorm () {
	nohup webstorm.sh &
	disown
}

url () {
	google-chrome-unstable $@
}

discord () {
	/usr/bin/discord --proxy-server=socks5://127.0.0.1:1630 > /dev/null 2> /dev/null &
	disown "%$(jobs | grep /usr/bin/discord | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
}

QQ () {
	/usr/bin/electron-qq > /dev/null 2> /dev/null &
	disown "%$(jobs | grep /usr/bin/electron-qq | grep -o -E '\[[0-9]+\]' | grep -o -E '[0-9]+')"
}

alias o="xdg-open"

alias hmcl="echo Don\\'t play Minecraft!"
unalias hmcl

export MINECRAFT="$H/.config/hmcl/.minecraft"
export MINECRAFT_ASSETS="$MINECRAFT/versions/1.16.5/1.16.5.jar.unzip/assets/minecraft"
export MINECRAFT_RES_CELESTE="$MINECRAFT/resourcepacks/Celeste"

willbot () {
	cds wb
	node src -is
}

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
	[[ -z "$FK_INIT" && (-f "$H/log/log-$today" || "$TERM" = linux) ]] || {
		echo "I'm ForkKILLET"
		touch "$H/log/log-$today"
		# konsole --noclose --nofork --workdir "$HOME/src/nodejs/WillBot/src" -e "node index.js -i" &; disown
		FK_INIT=
	}
}

w msml && {
	echo -e "\033[1;35m今天也是美好的一天呢～赞美 masnn （）\033[0m"
}

