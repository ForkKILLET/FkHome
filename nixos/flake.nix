{
  description = "ForkKILLET's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay";
    };
  };

  outputs = inputs@{
    nixpkgs,
    chinese-fonts-overlay,
    ...
  }: {
    nixosConfigurations.fkni = nixpkgs.lib.nixosSystem {
      modules = let
        configurationModule = ./configuration.nix;
        chineseFontsModule = { pkgs, ... }: {
          nixpkgs = {
            overlays = [
              inputs.chinese-fonts-overlay.overlays.default
            ];
          };
          fonts.packages = with pkgs; [
            windows-fonts
          ];
        };
      in [
        configurationModule
        chineseFontsModule
      ];
    };
  };
}