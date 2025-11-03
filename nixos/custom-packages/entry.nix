{ ... }: {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    olympus-unwrapped = callPackage ./olympus-unwrapped/package.nix {};
    olympus = callPackage ./olympus/package.nix {};
    baidunetdisk = callPackage ./baidunetdisk/default.nix {};
    openmv-ide-bin = callPackage ./openmv-ide-bin/default.nix {};
    stcgal = callPackage ./stcgal/default.nix {};
  };
}