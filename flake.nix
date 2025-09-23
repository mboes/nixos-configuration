{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";
    systems.url = "github:nix-systems/default";

    # Walker as a flake input until it becomes part of Nixpkgs.
    walker.url = "github:abenz1267/walker";
  };
  outputs =
    {
      self,
      nixpkgs,
      secrets,
      systems,
      walker,
      ...
    }:
    let
      myModules = deviceConfig: [
        secrets.nixosModules.default
        walker.nixosModules.default
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
