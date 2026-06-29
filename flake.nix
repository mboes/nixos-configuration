{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";
    systems.url = "github:nix-systems/default";

    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";
  };
  outputs =
    {
      self,
      nixpkgs,
      secrets,
      systems,
      ...
    }:
    let
      myModules = deviceConfig: [
        secrets.nixosModules.default
        ./configuration.nix
        deviceConfig
      ];
    in
    {
      nixosConfigurations = {
        quito = nixpkgs.lib.nixosSystem {
          modules = myModules ./devices/quito/hardware-configuration.nix;
        };
        cali = nixpkgs.lib.nixosSystem {
          modules = myModules ./devices/cali/hardware-configuration.nix;
        };
      };
      formatter = nixpkgs.lib.genAttrs (import systems) (
        system: nixpkgs.legacyPackages.${system}.nixfmt-tree
      );
    };
}
