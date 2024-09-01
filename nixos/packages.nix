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
    dog
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
  ];

  clangPkgs = [
    gcc
    gdb
    cmake
  ];

  javascriptPkgs = [
    nodejs
    pnpm
    yarn
  ];

  haskellPkgs = with haskellPackages; [
    ghc
    haskell-language-server
  ];

  rustPkgs = [
    rustup
  ];

  androidPkgs = [
      android-studio
  ];

  desktopPkgs = [
    xclip
    desktop-file-utils
    vscode
    qq
    google-chrome
    telegram-desktop
    zotero
    discord-canary
    vlc
    netease-cloud-music-gtk
    libreoffice
    lightspark
    obs-studio
    nur.repos.linyinfeng.wemeet
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
    filelight
    kdenlive
  ]);

  gamePkgs = [
    prismlauncher
    olympus
  ];

  winePkgs = [
    wineWowPackages.waylandFull
    winetricks
    samba
  ];
};
in {
  environment.systemPackages = foldlSet opCon [] packages;
}