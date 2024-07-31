{ ... }: {
  nixpkgs.config.packageOverrides = pkgs: with pkgs; {
    olympus = callPackage ./olympus/package.nix {};
  };
}