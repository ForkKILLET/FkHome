{ pkgs, ... }:
with pkgs;
with builtins;
with (import ./utilities.nix);
let packages = {
  cliPkgs = [
    git
    gh
    vim
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
  ];

  packagePackages = [
    nix-index
    dpkg
    patchelf
  ];

  mcuPackages = [
    sdcc   
  ];

  clangPkgs = [
    gcc
    gdb
    cmake
    gnumake
  ];

  javascriptPkgs = [
    nodejs-slim_latest
    pnpm
    yarn
  ];

  haskellPkgs = with haskellPackages; [
    ghc
    haskell-language-server
    stack
  ];

  rustPkgs = [
    rustup
  ];

  androidPkgs = [
      android-studio
  ];

  desktopPkgs = [
    nur.repos.linyinfeng.wemeet
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
    lightspark
    aseprite
    baidunetdisk
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
    filelight
    kdenlive
    kmail
    accounts-qt
    qtbase
    kmail-account-wizard
    krita
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
    wineWowPackages.waylandFull
    winetricks
    samba
  ];

  carPkgs = [
    socat
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