{
  description = "ForkKILLET's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = {
    nixpkgs,
    ...
  }: {
    nixosConfigurations.fkni = nixpkgs.lib.nixosSystem {
      modules = let
        configuration = ./configuration.nix;
      in [
        configuration
      ];
    };
  };
}