{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" ];
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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.extraPackages = [ pkgs.intel-media-driver ];
}
