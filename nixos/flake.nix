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

    chinese-fonts-overlay = {
      url = "github:brsvh/chinese-fonts-overlay";
    };
  };

  outputs = {
    nixpkgs,
    ...
  }@inputs: {
    nixosConfigurations.fkni =
      let
        originalPkgs = import nixpkgs {
          system = "x86_64-linux";
          config = {
            allowUnfree = true;
          };
        };
      in nixpkgs.lib.nixosSystem {
        specialArgs = inputs // { inherit originalPkgs; };
        modules = [
          ./configuration.nix

          inputs.nur-xddxdd.nixosModules.setupOverlay
          inputs.nur-xddxdd.nixosModules.nix-cache-attic
        ];
      };
  };
}