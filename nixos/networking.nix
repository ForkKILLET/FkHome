{ pkgs, config, ... }:
let
  user = config.users.users.forkkillet;
  commonDir = "${user.home}/.config/common";
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
        privateKeyFile = "${commonDir}/wireguard-private.txt";
        peers = [
          {
            publicKey = "fbuEQijU23yftndhhXwD6k3i3sHPezDsgmkQ+MA6NFI=";
            endpoint = "hjp0aj1a3c9.vpn.mynetname.net:1950";
            allowedIPs = [ "192.168.88.0/24" ];
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };

  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true;
    kernel = "https://boot.netboot.xyz";
  };

  services.v2raya.enable = true;

  services.frp = {
    enable = false;
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
