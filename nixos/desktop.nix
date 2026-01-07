{ pkgs, ... }: {
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];

    # Configure keymap in X11
    xkb = {
      variant = "";
      layout = "cn";
    };
  };

  # To fix KDE taskbar scale problems in X11.
  # <https://www.reddit.com/r/kde/comments/xk4r83/kde_display_scale_200_x11_taskbar_stays_the_same/>
  environment.sessionVariables = {
    PLASMA_USE_QT_SCALING = "1";
  };

  # Enable the KDE Plasma Desktop Environment, with the default session set to X11.
  services.displayManager = {
    sddm.enable = true;
    defaultSession = "plasmax11";
  };
  services.desktopManager.plasma6.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # IME
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      kdePackages.fcitx5-qt
      fcitx5-rime
      fcitx5-anthy
      fcitx5-material-color
    ];
  };

  # Fonts
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      wqy_microhei
      nerd-fonts.fira-code
      sarasa-gothic
      jetbrains-mono
      ipafont # Japanese fonts
      # windows-fonts-local
    ];
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      useEmbeddedBitmaps = true;
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [ "FiraCode Nerd Font Mono" ];
        sansSerif = [ "Noto Sans CJK SC" ];
        serif = [ "Noto Serif CJK SC" ];
      };
      localConf = ''
        <match target="font">
          <test name="family" qual="first">
            <string>Noto Color Emoji</string>
          </test>
          <edit name="antialias" mode="assign">
            <bool>false</bool>
          </edit>
        </match>
      '';
    };
    enableDefaultPackages = true;
  };
}
