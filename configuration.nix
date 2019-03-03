{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    cleanTmpDir = true;
    kernelPackages = pkgs.linuxPackages_latest;
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

  i18n = {
    consoleKeyMap = "dvorak";
    defaultLocale = "fr_FR.UTF-8";
  };

  time.timeZone = "Europe/Paris";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    udisks
    zsh
  ];

  hardware.bluetooth.enable = true;
  hardware.opengl.extraPackages = [ pkgs.vaapiIntel ];
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  programs.slock.enable = true;

  services.openssh.enable = true;

  services.keybase.enable = true;

  services.kmscon = {
    enable = true;
    extraConfig = ''
      font-name=Inconsolata
      font-dpi=276
      xkb-layout=us
      xkb-variant=dvorak
      '';
    hwRender = true;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.userServices = true;
  };

  services.redshift = {
    enable = true;
    latitude = "49.8";
    longitude = "2.3";
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.storageDriver = "zfs";

  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];

    windowManager.xmonad.enable = true;
    windowManager.xmonad.extraPackages = self: [ self.xmonad-contrib ];
    windowManager.default = "xmonad";
    desktopManager.default = "none";

    displayManager.sddm = {
      enable = true;
      # autoLogin.enable = true;
      # autoLogin.user = "mboes";
    };
    displayManager.sessionCommands = ''
      export XCURSOR_PATH=${pkgs.gnome3.adwaita-icon-theme}/share/icons
      conky -d
      urxvtd -q -f -o
      xmodmap .Xmodmap
      xsetroot -solid black
      xset r rate 200 40
      xset b off
      '';

    synaptics.enable = true;
    synaptics.twoFingerScroll = true;
    synaptics.tapButtons = false;
    synaptics.additionalOptions = ''
      Option "CoastingFriction" "30"
      Option "VertScrollDelta" "-243"
      Option "HorizScrollDelta" "-243"
      '';

    modules = with pkgs; [
      xf86_input_wacom
    ];

    layout = "us,gr";
    xkbVariant = "dvorak,extended";
    xkbOptions = "terminate:ctrl_alt_bksp,ctrl:nocaps,eurosign:e,altwin:swap_alt_win,grp:shifts_toggle,lv3:lalt_switch,eurosign:e";

    config = ''
      Section "InputClass"
          Identifier "touchpad catchall"
          Driver "synaptics"
          MatchIsTouchpad "on"
          MatchDevicePath "/dev/input/event*"
          Option "CoastingFriction"       "30"
          Option "VertScrollDelta"        "-243"
          Option "HorizScrollDelta"       "-243"
      EndSection
    '';

    dpi = 276;
  };

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
      inconsolata
      noto-fonts
      noto-fonts-emoji
      orbitron
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

  nix.buildCores = 0;
  nix.trustedBinaryCaches = [
    "http://cache.nixos.org"
    "http://hydra.nixos.org"
  ];
  nix.binaryCachePublicKeys = [ "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs=" ];
  nix.trustedUsers = [ "mboes" ];
}
