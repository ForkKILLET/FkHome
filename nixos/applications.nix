{ pkgs, ... }: {
  virtualisation = {
    virtualbox = {
      host.enable = true;
    };
    docker = {
      enable = true;
    };
  };

  services.udev.packages = with pkgs; [
    openmv-ide-bin
  ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
    libraries = with pkgs; [
      stdenv.cc.cc
      libGL
      libgcc
    ];
  };

  programs.direnv.enable = true;

  programs.firefox = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [ noto-fonts-cjk-sans ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;

  programs.kdeconnect.enable = true;

  services.todesk = {
    enable = true;
  };
}