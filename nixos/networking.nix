{ pkgs, config, ... }:
let
  user = config.users.users.forkkillet;
  privateDir = "${user.home}/Logs/private";
in {
  networking = {
    hostName = "fkni";
    networkmanager.enable = true;
    firewall.enable = false;

    wireguard.interfaces = {
      wg0 = {
        ips = [
          "192.168.216.4/32"
          "fc00:0:0:216::4/128"
        ];
        listenPort = 51820;
        privateKeyFile = "${privateDir}/wireguard-private.txt";
        peers = [
          {
            publicKey = "fbuEQijU23yftndhhXwD6k3i3sHPezDsgmkQ+MA6NFI=";
            endpoint = "genshin.asm.ms:1950";
            allowedIPs = [ "192.168.88.0/24" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.frp = {
    instances = {
      terraria = {
        enable = true;
        role = "client";
        settings = {
          serverAddr = "192.168.88.4";
          serverPort = 1650;

          proxies = [
            {
              name = "terraria";
              type = "tcp";
              localIp = "127.0.0.1";
              localPort = 7777;
              remotePort = 7777;
            }
          ];
        };
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
