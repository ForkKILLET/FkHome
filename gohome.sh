QB='E -n "(y/n) "; read -k1 Q; if [[ $Q =~ [Yy] ]]; then E;'
QE='else E "\n^"; fi'

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

[[ -n "$GHPROXY" ]] && EE "# Using ghproxy.com"

EE "# Constructing dirctories."
mkdir -p ~/{src,bin,res}

EE "# Linking dotfiles."
for f in .zshrc .gitconfig; do
	rm -f ~/\$f
	ln -s ~/_/\$f ~/\$f
	E "    * \$f"
done

EE "# Sourcing .zshrc"
source ~/_/.zshrc

EE "# Linking Fcitx dotfiles?"
$QB
	E "    * .phrases"
	rm -f ~/.config/fcitx/data/QuickPhrase.mb
	ln -s ~/_/fcitx/.phrases ~/.config/fcitx/data/QuickPhrase.mb

	E "    * .config"
	rm -f ~/.config/fcitx/config
	ln -s ~/_/fcitx/.config ~/.config/fcitx/config
	
$QE

EE "# Initializing submodules."
git submodule update --init --recursive

cd ~/_

EE "# Calling Vim?"
$QB
	zsh ./FkVim/gohome.sh 1
$QE

EE "# Welcoming Main."

SHELL

