{ config, pkgs, ... }:

let secrets = import ./secrets.nix; in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    cleanTmpDir = true;
    kernel.sysctl = {
      "net.ipv6.conf.all.use_tempaddr" = 2;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "exfat" "zfs" ];
    zfs.enableUnstable = true;
    zfs.requestEncryptionCredentials = true;
  };

  networking = rec {
    hostName = "cayenne";
    hostId = "493dffe1";
    networkmanager.enable = true;
    extraHosts = "127.0.0.1 ${hostName}";
  };

  console.keyMap = "dvorak";
  i18n.defaultLocale = "fr_FR.UTF-8";

  time.timeZone = secrets.timezone;
  location.latitude = secrets.latitude;
  location.longitude = secrets.longitude;

  system.stateVersion = "19.03";

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [(self: super: {
      redshift = super.redshift.overrideAttrs (old: {
        name = "redshift-wayland";
        src = self.fetchFromGitHub {
          owner = "minus7";
          repo = "redshift";
          rev = "420d0d534c9f03abc4d634a7d3d7629caf29b4b6";
          sha256 = "12dwb96i4pbny5s64k6k4f8k936xa41zvcjhv54wv0ax471ymls7";
        };
      });
    })];
    };

  environment = {
    systemPackages = with pkgs; [
      gnupg
      zsh
    ];
  };

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  hardware.u2f.enable = true;

  powerManagement.powertop.enable = true;
  powerManagement.cpuFreqGovernor = "powersave";

  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  programs.slock.enable = true;
  programs.zsh.enable = true;
  programs.light.enable = true;
  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [ kitty swaylock swayidle xwayland dmenu waybar mako ];
    extraSessionCommands = ''
      export GDK_DPI_SCALING=3
    '';
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
      nssmdns = true;
      publish.enable = true;
      publish.userServices = true;
    };
    redshift = {
      enable = true;
      # brightness.night = "0.2";
      extraOptions = [ "-m" "wayland" ];
    };
    upower.enable = true;
    xserver = {
      enable = true;
      displayManager.defaultSession = "sway";
      displayManager.lightdm = {
        enable = true;
        greeter.enable = false;
        autoLogin.enable = true;
        autoLogin.timeout = 0;
        autoLogin.user = "mboes";
      };
    };
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

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  fonts = {
    fontconfig = {
      enable = true;
      dpi = 276;
    };
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      #corefonts
      dejavu_fonts
      font-awesome
      fira-code
      inconsolata
      iosevka
      noto-fonts
      noto-fonts-emoji
      orbitron
      roboto
      terminus_font
      ubuntu_font_family
    ];
  };

  security.sudo.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.mboes = {
    description = "Mathieu Boespflug";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "audio" "video" "docker" "vboxusers" "networkmanager" ];
    shell = "/run/current-system/sw/bin/zsh";
  };

  nix = {
    useSandbox = true;
    trustedBinaryCaches = [
      "http://cache.nixos.org"
      "http://hydra.nixos.org"
    ];
    binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
    trustedUsers = [ "mboes" ];
    buildMachines = secrets.buildMachines;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
