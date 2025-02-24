{ pkgs, ... }:
with pkgs;
with builtins;
with (import ./utilities.nix);
let packages = {
  cliPkgs = [
    git
    gh
    vim
    neovim
    lsd
    fzf
    zip
    unzip
    delta
    tealdeer
    bat
    wget
    screenfetch
    ripgrep
    duf
    dust
    fd
    bottom
    procs
    httpie
    broot
    wakatime-cli
    tokei
    nil
    lsof
    hexyl
    wireguard-tools
    ffmpeg
    tree
    postgresql
    jq
    unrar-wrapper
    pandoc
    djvu2pdf
    nushell
    screen
    p7zip
    rlwrap
    rename
    bc
    ngrok
    nh
  ];

  packagePackages = [
    nix-index
    dpkg
    patchelf
  ];

  mcuPackages = [
    sdcc
    openmv-ide-bin
  ];

  clangPkgs = [
    gcc
    gdb
    clang
    clang-tools
    cmake
    gnumake
  ];

  javascriptPkgs = with nodePackages; [
    nodejs_latest
    pnpm
    yarn

    tsun
    node-gyp
  ];

  haskellPkgs = with haskellPackages; [
    ghc
    haskell-language-server
    stack
    Agda
  ];

  racketPkgs = [
    racket
  ];

  rustPkgs = [
    rustup
  ];

  androidPkgs = [
      android-studio
  ];

  desktopPkgs = [
    xorg.xkbcomp
    xclip
    desktop-file-utils
    vscode
    qq
    google-chrome
    microsoft-edge
    telegram-desktop
    zotero
    discord-canary
    netease-cloud-music-gtk
    libreoffice
    # lightspark
    # aseprite
    baidunetdisk
    nur.repos.linyinfeng.wemeet
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
    filelight
    kdenlive
    kmail
    accounts-qt
    qtbase
    kmail-account-wizard
    # krita
    kalendar
  ]);

  videoAndAudioPkgs = [
    obs-studio
    vlc
    peek

    helvum
    qpwgraph
  ];

  gamePkgs = [
    prismlauncher
    olympus
  ];

  winePkgs = [
    winetricks
    samba
  ];

  notePkgs = [
    typst
    typora
    texliveFull
  ];
};
in {
  environment.systemPackages = foldlSet opCon [] packages;
}
