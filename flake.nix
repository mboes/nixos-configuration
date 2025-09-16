{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    # This repository is private.
    secrets.url = "git+ssh://git@github.com/mboes/nixos-configuration-secrets";
  };
  outputs = { self, nixpkgs, secrets }: {
    nixosConfigurations.quito = nixpkgs.lib.nixosSystem {
      modules = [
        secrets.nixosModules.default
        ./configuration.nix
        ./devices/quito/hardware-configuration.nix
      ];
    };
    nixosConfigurations.cali = nixpkgs.lib.nixosSystem {
      modules = [
        secrets.nixosModules.default
        ./configuration.nix
        ./devices/cali/hardware-configuration.nix
      ];
    };
  };
}
