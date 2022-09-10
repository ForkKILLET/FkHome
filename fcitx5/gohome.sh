QB='E -n "\033[34m(y/n) \033[0m"; read -k1 Q; if [[ $Q =~ [Yy] ]]; then E;'
QE='else E "\n\033[34m^\033[0m"; fi'

indent=$1

zsh << SHELL

E() {
	[[ -n "$indent" ]] && for i in {1..$indent}; do echo -n "    "; done
	echo \$*
}

EE() {
	echo -n "\033[32m"
	E \$*
    echo -n "\033[0m"
}

cd ~/_/fcitx5

EE "# Linking config"
rm -f ~/.config/fcitx5/config
ln -s ~/_/fcitx5/config ~/.config/fcitx5/config

EE "# Writing to pam_environment"

if [[ ! -f ~/.pam_environment ]]; then
	cat ./.pam_environment > ~/.pam_environment
fi

EE "# Welcoming Fcitx5"

SHELL
