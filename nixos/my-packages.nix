{ pkgs }: with builtins; with pkgs; let myPackages = [
  cliTools = [
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
  ];

  jsTools = [
    nodejs
    pnpm
  ];

  haskellTools = [
    ghc
  ];

  desktopApps = [
    xclip
    vscode
    qq
    google-chrome
    prismlauncher
  ] ++ (with kdePackages; [
    kolourpaint
    partitionmanager
  ]);
]; in {
  myPackages
}
