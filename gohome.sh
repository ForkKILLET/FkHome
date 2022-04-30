QB='read -k1 "Q?(y/n) "; if [[ $Q =~ [Yy] ]]; then E;'
QE='else E "\n^"; fi'

zsh << SHELL

E() {
	echo "\$1"
}

E "# Using Windows symlink?"
$QB
	ln() {
		[ \$1 = -s ] && shift
		cmd "/C mklink '\$2' '\$1'\r\n"
	}
$QE

E "# Constructing dirctories."
mkdir -p ~/{src,bin,rbin,res}

E "# Linking dotfiles."
for f in .zshrc .gitconfig; do
	rm -f ~/\$f
	ln -s ~/_/\$f ~/\$f
	E "    * \$f"
done

E "# Sourcing .zshrc"
source ~/_/.zshrc

E "# Linking Fcitx dotfiles?"
$QB
	E "    * .phrases"
	rm -f ~/.config/fcitx/data/QuickPhrase.mb
	ln -s ~/_/fcitx/.phrases ~/.config/fcitx/data/QuickPhrase.mb

	E "    * .config"
	rm -f ~/.config/fcitx/config
	ln -s ~/_/fcitx/.config ~/.config/fcitx/config
	
$QE

E "# Initializing submodules."
git submodule update --init --recursive
cd ~/_

E "# Calling Vim?"
$QB
	zsh ./FkVim/gohome.sh 1
$QE

E "# Welcoming Main."

SHELL

