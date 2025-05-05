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
    devenv
    busybox
  ];

  packagePackages = [
    nix-index
    dpkg
    patchelf
  ];

  mcuPackages = [
    sdcc
    stcgal
    # openmv-ide-bin
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
    bun

    node-gyp
  ];

  pythonPkgs = [
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
    # lightspark
    # aseprite
    # baidunetdisk
    wemeet
    wpsoffice-cn
    fiddler-everywhere
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
    merkuro # kalendar
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
    # olympus
  ];

  winePkgs = [
    wine64
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
