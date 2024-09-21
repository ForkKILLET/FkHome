{ pkgs, config, ... }: let
  user = config.users.users.forkkillet;
in {
  networking = {
    hostName = "fkni";
    networkmanager.enable = true;

    firewall = {
      enable = false;
      allowedTCPPorts = [
        80
        443
        8081 # Expo Go
      ];
      allowedUDPPorts = [
        51820 # Wireguard
      ];
    };

    wireguard.interfaces = let
      publicKey = "q+J/pOvfzgJMQxGdxL0w1i06z+Qz798yzKr8xU6nK1g=";
      endpoint = "genshin.asm.ms:13231";
    in {
      wg0 = {
        ips = [ "10.0.6.0/8" ];
        listenPort = 51820;
        privateKeyFile = "${user.home}/log/log-wireguard-private";
        peers = [
          {
            inherit publicKey;
            inherit endpoint;
            allowedIPs = [ "192.168.88.0/24" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  services.v2raya.enable = true;

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
}