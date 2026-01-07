{
  description = "ForkKILLET's NixOS flake";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    nur-xddxdd = {
      url = "github:xddxdd/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    ...
  }@inputs: {
    nixosConfigurations.fkni = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        inputs.nur-xddxdd.nixosModules.setupOverlay
        inputs.nur-xddxdd.nixosModules.nix-cache-attic
      ];
    };
  };
}