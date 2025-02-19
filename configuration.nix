{ config, pkgs, ... }:

let secrets = import ./secrets.nix; in
{
  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = {
      "net.ipv6.conf.all.use_tempaddr" = 2;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "exfat" "zfs" ];
    zfs.requestEncryptionCredentials = true;
  };

  networking = rec {
    networkmanager.enable = true;
    networkmanager.insertNameservers = ["1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001"];
  };

  console.keyMap = "dvorak";
  i18n.defaultLocale = "fr_FR.UTF-8";

  time.timeZone = secrets.timezone;
  location.latitude = secrets.latitude;
  location.longitude = secrets.longitude;

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = 1;
    systemPackages = with pkgs; [
      gnupg
      zsh
    ];
  };

  services.blueman.enable = true;
  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.graphics.driSupport32Bit = true;

  powerManagement.powertop.enable = true;

  programs = {
    gnupg.agent.enable = true;
    gnupg.agent.enableSSHSupport = true;
    zsh.enable = true;
    light.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
  };

  services = {
    emacs = {
      enable = true;
      defaultEditor = true;
    };
    fwupd.enable = true;
    openssh.enable = true;
    pcscd.enable = true;
    printing.enable = true;
    printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
      publish.userServices = true;
    };
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "mboes";
        };
        default_session = initial_session;
      };
    };
    hypridle.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    udev.extraRules = ''
      # Workaround USB suspend not working for Logitech G500 mouse.
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c068", ATTR{power/autosuspend}="-1"
      # Prevent GoPro from connecting. Should only charge.
      SUBSYSTEM=="usb", ATTR{idVendor}=="2672", ATTR{idProduct}=="000d", ATTR{authorized}="0"
    '';
    upower.enable = true;
  };

  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = "120";
    };
  };
  systemd.services.suspend-on-low-battery =
    let battery-level-sufficient =
          pkgs.writeShellScriptBin "battery-level-sufficient" ''
            test "$(cat /sys/class/power_supply/BAT1/status)" != Discharging \
              || test "$(cat /sys/class/power_supply/BAT1/capacity)" -ge 10
            '';
    in
    { serviceConfig = { Type = "oneshot"; };
      onFailure = [ "suspend.target" ];
      script = "${battery-level-sufficient}/bin/battery-level-sufficient";
    };

  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.extraPackages = [ pkgs.zfs ];
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "zfs";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      font-awesome
      fira-code
      fira-code-symbols
      inconsolata
      iosevka
      noto-fonts
      noto-fonts-emoji
      orbitron
      roboto
      terminus_font
    ];
  };

  security.rtkit.enable = true;
  security.sudo.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.mboes = {
    description = "Mathieu Boespflug";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "docker" "podman" "vboxusers" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nix = {
    buildMachines = secrets.buildMachines;
    settings = {
      trusted-substituters = [
        "http://cache.nixos.org"
        "http://hydra.nixos.org"
      ];
      trusted-public-keys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
      trusted-users = [ "mboes" ];
    };
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
