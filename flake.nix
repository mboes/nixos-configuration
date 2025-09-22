{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";
  };
  outputs = { self, nixpkgs, secrets, ... }:
    let myModules = deviceConfig: [
          secrets.nixosModules.default
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
