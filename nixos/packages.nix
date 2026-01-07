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
    fastfetch
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
    devenv
    busybox
  ];

  packagePackages = [
    nix-index
    dpkg
    patchelf
  ];

  mcuPackages = [
  ];

  clangPkgs = [
    gcc
    gdb
    clang
    clang-tools
    lldb
    cmake
    xmake
    gnumake
  ];

  javascriptPkgs = with nodePackages; [
    nodejs_latest
    pnpm
    yarn
    bun

    node-gyp
  ];

  pythonPkgs = [
    python3
    uv
  ];

  haskellPkgs = with haskellPackages; [
    ghc
    haskell-language-server
    stack
    Agda
  ];

  dotnetPkgs = [
    dotnet-sdk
  ];

  rustPkgs = [
    rustup
  ];

  desktopPkgs = [
    xorg.xkbcomp
    xclip
    desktop-file-utils
    vscode
    qq
    google-chrome
    telegram-desktop
    zotero
    discord-canary
    netease-cloud-music-gtk
    # lightspark
    # aseprite
    baidunetdisk
    wemeet
    wpsoffice-cn
    wechat
    inkscape
    teamspeak6-client
  ] ++ (with kdePackages; [
    kamoso
    kolourpaint
    partitionmanager
    filelight
    kdenlive
    kmail
    accounts-qt
    qtbase
    kmail-account-wizard
    krita
    merkuro
  ]);

  videoAndAudioPkgs = [
    obs-studio
    vlc
    peek
  ];

  gamePkgs = [
    prismlauncher
    (olympus.override {
      celesteWrapper = steam-run;
    })
  ];

  winePkgs = [
    wine64
    winetricks
    samba
  ];

  notePkgs = [
    typst
    typora
  ];

  imePkgs = [
    rime-zhwiki
  ];

  databasePkgs = [
    mongodb-compass
    postgresql
  ];

  androidPkgs = [
    android-studio
  ];
};
in {
  environment.systemPackages = foldlSet opCon [] packages;
}
