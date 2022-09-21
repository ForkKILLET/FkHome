
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

cd ~/_/rust

if which rustup 2>&1 > /dev/null; then
	EE "# Rustup already installed"
else
	EE "# Installing Rustup"

	export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
	export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

EE "# Linking dotfiles"

E "    * .cargo/config"
rm -rf ~/.cargo/config
ln -s ~/_/rust/cargo.config ~/.cargo/config

EE "# Welcoming Rust"

SHELL
