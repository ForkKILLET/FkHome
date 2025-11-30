{ pkgs, ... }: {
  virtualisation = {
    virtualbox = {
      host.enable = true;
    };
    docker = {
      enable = true;
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "local" ];

    authentication = pkgs.lib.mkOverride 10 ''
      #type database db-user origin-addr  auth-method
      local all      all                  trust
      host  all      all     127.0.0.1/32 trust
      host  all      all     ::1/128      trust
    '';

    identMap = ''
      #map-name system-user db-user
      superuser root        postgres
      superuser forkkillet  postgres
      superuser postgres    postgres
      superuser /^(.*)$     \1
    '';
  };

  programs.nix-ld = {
    enable = true;
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

  programs.kdeconnect.enable = true;

  services.todesk.enable = true;
}