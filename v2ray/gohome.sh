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

cd ~/_/v2ray

if ! which openssl 2>&1 > /dev/null; then
	EE "# Openssl not installed"
	exit 1
fi

EE "# Decrypting config"

mkdir -p ~/.config/v2ray
rm -rf ~/.config/v2ray/config
openssl enc -aes-128-cbc -pbkdf2 -d -in ./config.enc -out ~/.config/v2ray/config

EE "# Welcoming V2Ray"

SHELL
