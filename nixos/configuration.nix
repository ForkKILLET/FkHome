{ config, pkgs, ... }: with builtins; {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking.
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.enable = false;
  };

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

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-gtk
        libsForQt5.fcitx5-qt
        fcitx5-rime
        fcitx5-anthy
        fcitx5-material-color
      ];
    };
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      variant = "";
      layout = "cn";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.forkkillet = {
    isNormalUser = true;
    description = "Fork Killet";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.zsh;
  security.sudo.wheelNeedsPassword = false;

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ipafont # Japanese fonts
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "Source Han Mono" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Source Han Serif" ];
      };
    };
    enableDefaultPackages = true;
  };

  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };
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
      "https://nix-bin.hydro.ac"
    ];
    accept-flake-config = true;
    max-jobs = 2;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "qtwebkit-5.212.0-alpha4"
    ];

    packageOverrides = with pkgs; pkgs: {
      olympus = callPackage ./custom-packages/olympus/package.nix {};
    };
  };

  # Packages
  environment.systemPackages = import ./packages.nix { inherit pkgs; };
  
  environment.shells = with pkgs; [ zsh ];

  # Docker
  virtualisation.docker.enable = true;

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [];
  };

  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng;
    quietMode = true;
    proxies = {
      v2raya = {
        enable = true;
        type = "http";
        host = "127.0.0.1";
        port = 1643;
      };
    };
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

  hardware.graphics.enable32Bit = true; # For steam

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.v2raya.enable = true;

  services.static-web-server = {
    enable = true;
    root = "/var/www/forkkillet";
    configuration = {
      directory-listing = false;
    };
  };

  # Fix that rtw88 doesn't work after suspending
  powerManagement.enable = true;
  powerManagement.resumeCommands = ''
    /run/current-system/sw/bin/modprobe rtw88_8822ce
  '';
  powerManagement.powerDownCommands = ''
    /run/current-system/sw/bin/modprobe -r rtw88_8822ce
  '';

  system.stateVersion = "24.11";
}
