{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";
    systems.url = "github:nix-systems/default";

    # Flake inputs until they become part of Nixpkgs.
    walker.url = "github:abenz1267/walker";
    walker.inputs.systems.follows = "systems";
    wiremix.url = "github:tsowell/wiremix";
    wiremix.inputs.nixpkgs.follows = "nixpkgs";
    wiremix.inputs.systems.follows = "systems";
  };
  outputs =
    {
      self,
      nixpkgs,
      secrets,
      systems,
      walker,
      wiremix,
      ...
    }:
    let
      myModules = deviceConfig: [
        secrets.nixosModules.default
        walker.nixosModules.default
        ({ config.environment.systemPackages = [ wiremix.packages.x86_64-linux.default ]; })
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
