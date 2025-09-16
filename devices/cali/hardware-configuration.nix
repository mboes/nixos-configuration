{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "tank/nixos/root";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "tank/nixos/home";
      fsType = "zfs";
    };

  fileSystems."/var/lib" =
    { device = "tank/nixos/var/lib";
      fsType = "zfs";
    };

  fileSystems."/var/log" =
    { device = "tank/nixos/var/log";
      fsType = "zfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1B5B-AE28";
      fsType = "vfat";
    };

  swapDevices = [ { label = "swap"; } ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "cali";
  networking.hostId = "5c17e9f9";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
  hardware.sane.enable = true;
  hardware.sane.drivers.scanSnap.enable = true;
  services.udev.packages = [ pkgs.sane-airscan ];
}
