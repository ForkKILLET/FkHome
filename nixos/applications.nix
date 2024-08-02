{ pkgs, ... }: {
  # virtualisation.docker.enable = true;

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

  programs.firefox.enable = true;

  programs.steam = {
    enable = true;
    fontPackages = with pkgs; [ noto-fonts-cjk ];
  };

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.adb.enable = true;

  services.static-web-server = {
    enable = false;
    listen = "[::]:1627";
    root = "/var/www/forkkillet";
    configuration = {
      directory-listing = false;
    };
  };
}