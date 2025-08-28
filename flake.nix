{
  description = "My NixOS configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };
  outputs = { self, nixpkgs }: {
    nixosConfigurations.quito = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./devices/quito/hardware-configuration.nix
      ];
    };
    nixosConfigurations.cali = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
        ./devices/cali/hardware-configuration.nix
      ];
    };
  };
}
