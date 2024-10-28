{ pkgs, ... }: with builtins; {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ./custom-packages/entry.nix
    ./packages.nix
    ./desktop.nix
    ./applications.nix
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "zh_CN.UTF-8";
      LC_IDENTIFICATION = "zh_CN.UTF-8";
      LC_MEASUREMENT = "zh_CN.UTF-8";
      LC_MONETARY = "zh_CN.UTF-8";
      LC_NAME = "zh_CN.UTF-8";
      LC_NUMERIC = "zh_CN.UTF-8";
      LC_PAPER = "zh_CN.UTF-8";
      LC_TELEPHONE = "zh_CN.UTF-8";
      LC_TIME = "zh_CN.UTF-8";
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.forkkillet = {
    isNormalUser = true;
    description = "Fork Killet";
    extraGroups = [ "networkmanager" "wheel" "kvm" "adbusers" "vboxusers" ];
  };
  users.defaultUserShell = pkgs.zsh;
  security.sudo.wheelNeedsPassword = false;

  # Shell
  environment.shells = with pkgs; [ zsh ];

  # Generation GC
  nix.optimise.automatic = true;
  # nix.gc = {
  #   automatic = true;
  #   dates = "daily";
  #   options = "--delete-older-than 7d";
  # };

  # Nix settings
  nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydro.ac:EytfvyReWHFwhY9MCGimCIn46KQNfmv9y8E2NqlNfxQ="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://mirrors.bfsu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://nix-bin.hydro.ac"
    ];
    accept-flake-config = true;
    max-jobs = 2;
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  system.stateVersion = "24.11";
}
