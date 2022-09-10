QB='E -n "\033[34m(y/n) \033[0m"; read -k1 Q; if [[ $Q =~ [Yy] ]]; then E;'
QE='else E "\n\033[34m^\033[0m"; fi'

zsh << SHELL

E() {
	echo \$*
}

EE() {
	echo -n "\033[32m"
	E \$*
    echo -n "\033[0m"
}

cd ~/_

EE "# Checking CLI config"

[[ -n "$GHPROXY" ]] && E "    * Using <ghproxy.com>."

EE "# Constructing dirctories"
mkdir -p ~/{src,bin,res}

EE "# Linking dotfiles"
for f in .zshrc .gitconfig; do
	rm -f ~/\$f
	ln -s ~/_/\$f ~/\$f
	E "    * \$f"
done

EE "# Sourcing .zshrc"
source .zshrc

EE "# Calling fcitx5?"
$QB
	zsh ./fcitx5/gohome.sh 1
	cd ~/_
$QE

EE "# Initializing submodules"
git submodule update --init --recursive

EE "# Calling Vim?"
$QB
	zsh ./FkVim/gohome.sh 1
	cd ~/_
$QE

EE "# Welcoming Main"

SHELL

