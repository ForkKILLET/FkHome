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

[[ -n "$GHPROXY" ]] && {
    E "    * Using <ghproxy.com>."
    export _GOHOME_GITHUB_PREFIX="https://ghproxy.com/"
}

[[ -n "$PROXYCMD" ]] && {
    E "    * Using proxy command '$PROXYCMD'."
    export _PROXY_PREFIX="$PROXYCMD "
}

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

EE "# Installing oh-my-zsh?"
$QB
    E "    * omz"
    if [[ ! -d $ZSH ]]; then
        ${_PROXY_PREFIX}git clone "${_GOHOME_GITHUB_PREFIX}https://github.com/robbyrussell/oh-my-zsh.git" $ZSH
    else
        E "      (skipped)"
    fi

    cd $ZSH/custom/plugins

    E "    * plugin: zsh-syntax-highlighting"
    ${_PROXY_PREFIX}git clone "${_GOHOME_GITHUB_PREFIX}https://github.com/zsh-users/zsh-syntax-highlighting.git"

    cd ~/_
$QE

EE "# Calling Fcitx5?"
$QB
    _GOHOME_INDENT=1 zsh ./fcitx5/gohome.sh 1
    cd ~/_
$QE

EE "# Calling Vim?"
$QB
    _GOHOME_INDENT=1 zsh ./vim/gohome.sh 1
    cd ~/_
$QE

EE "# Welcoming Main"

rehash

SHELL

