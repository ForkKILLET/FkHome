{ pkgs }:
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
    ];

    buildPkgs = [
      gcc
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

    desktopPkgs = [
      xclip
      desktop-file-utils
      vscode
      qq
      google-chrome
      prismlauncher
      telegram-desktop
      zotero
      olympus
      discord-canary
      vlc
    ] ++ (with kdePackages; [
      kolourpaint
      partitionmanager
      filelight
    ]);

    winePkgs = [
      wineWowPackages.stable
      wineWowPackages.waylandFull
      winetricks
      samba
    ];
  };
  in foldlSet opCon [] packages