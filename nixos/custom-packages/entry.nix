{ ... }: {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    olympus = callPackage ./olympus/default.nix {};
    baidunetdisk = callPackage ./baidunetdisk/default.nix {};
  };
}