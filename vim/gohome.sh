QB='E -n "\033[34m(y/n) \033[0m"; read -k1 Q; if [[ $Q =~ [Yy] ]]; then E;'
QE='else E "\n\033[34m^\033[0m"; fi'

zsh << SHELL

E() {
	[[ -n "$_GOHOME_INDENT" ]] && for i in {1..$_GOHOME_INDENT}; do echo -n "    "; done
	echo \$*
}

EE() {
	echo -n "\033[32m"
	E \$*
    echo -n "\033[0m"
}

cd ~/_

EE "# Constructing directories"
mkdir -p ~/.vim

EE "# Linking dotfiles"
E "    * .vim"
rm -f ~/.vim/vimrc
ln -s ~/_/FkVim/vimrc ~/.vim/vimrc

EE "# Installing vim-plug?"
$QB
	git clone "${_GOHOME_GITHUB_PREFIX}https://github.com/junegunn/vim-plug.git" $VIMFILES/autoload
$QE

EE "# Welcoming Vim"

SHELL

