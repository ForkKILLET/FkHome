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

cd ~/_/fcitx5

EE "# Linking config"

E "    * config"
rm -f ~/.config/fcitx5/config
ln -s ~/_/fcitx5/config ~/.config/fcitx5/config

E "    * conf/"
rm -rf ~/.config/fcitx5/conf
ln -s ~/_/fcitx5/conf ~/.config/fcitx5/conf

E "    * data/"
rm -rf ~/.local/share/fcitx5/data
ln -s ~/_/fcitx5/data ~/.local/share/fcitx5/data

E "    * rime/"
for file in \$(ls ~/_/fcitx5/rime); do
	rm -f ~/.local/share/fcitx5/rime/\$file
	ln -s ~/_/fcitx5/rime/\$file ~/.local/share/fcitx5/rime/\$file
done

EE "# Welcoming Fcitx5"

SHELL
