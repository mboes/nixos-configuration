{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";

    # Walker as a flake input until it becomes part of Nixpkgs.
    walker.url = "github:abenz1267/walker";
  };
  outputs = { self, nixpkgs, secrets, walker, ... }:
    let myModules = deviceConfig: [
          secrets.nixosModules.default
          walker.nixosModules.default
          ./configuration.nix
          deviceConfig
        ];
    in {
      nixosConfigurations.quito = nixpkgs.lib.nixosSystem {
        modules = myModules ./devices/quito/hardware-configuration.nix;
      };
      nixosConfigurations.cali = nixpkgs.lib.nixosSystem {
        modules = myModules ./devices/cali/hardware-configuration.nix;
      };
    };
}
