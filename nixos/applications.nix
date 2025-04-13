{ pkgs, ... }: {
  virtualisation.virtualbox = {
    host.enable = true;
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

  programs.firefox.enable = true;

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

  services.open-webui = {
    enable = false;
    port = 4242;
    host = "0.0.0.0";
    openFirewall = false;
    environment = {
        DATA_DIR = "/data/open-webui";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        WEBUI_AUTH = "False";
    };
  };

  services.todesk = {
    enable = true;
  };
}