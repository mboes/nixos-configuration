{
  config,
  lib,
  pkgs,
  ...
}:

{
  boot = {
    tmp.cleanOnBoot = true;
    kernel.sysctl = {
      "net.ipv6.conf.all.use_tempaddr" = 2;
    };
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [
      "exfat"
      "zfs"
    ];
    zfs.requestEncryptionCredentials = true;
  };

  networking.useNetworkd = true;
  networking.wireless.iwd.enable = true;

  i18n.defaultLocale = "fr_FR.UTF-8";

  nixpkgs = {
    config.allowUnfree = true;
  };

  environment = {
    sessionVariables.NIXOS_OZONE_WL = 1;
    systemPackages = import ./system-packages.nix { inherit pkgs; };
  };

  hardware.bluetooth.enable = true;
  hardware.cpu.intel.updateMicrocode = true;
  hardware.keyboard.zsa.enable = true;

  powerManagement.powertop.enable = true;

  programs = {
    _1password.enable = true;
    _1password-gui.enable = true;
    direnv.enable = true;
    direnv.enableZshIntegration = true;
    evince.enable = true;
    firefox.enable = true;
    fzf = {
      fuzzyCompletion = true;
      keybindings = true;
    };
    git.enable = true;
    git.lfs.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
    };
    hyprlock.enable = true;
    light.enable = true;
    light.brightnessKeys.enable = true;
    mosh.enable = true;
    vim.enable = true;
    walker.enable = true;
    waybar.enable = true;
    zsh = {
      enable = true;
      enableGlobalCompInit = false;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      promptInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      '';
      shellInit = ''
        export ZDOTDIR=''${XDG_CONFIG_HOME:-$HOME/.config}/zsh
      '';
    };
  };

  services = {
    blueman.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish.enable = true;
      publish.userServices = true;
    };
    emacs = {
      enable = true;
      defaultEditor = true;
      package = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: [epkgs.jinx]);
    };
    fwupd.enable = true;
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
    openssh.enable = true;
    printing.enable = true;
    printing.stateless = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    resolved.enable = true;
    udev.extraRules = ''
      # Workaround USB suspend not working for Logitech G500/G502 mice.
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c068", ATTR{power/autosuspend}="-1"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c099", ATTR{power/autosuspend}="-1"
      # Avoid lag caused by autosuspend for ZSA Voyager keyboard.
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1977", ATTR{power/autosuspend}="-1"
      # Prevent GoPro from connecting. Should only charge.
      SUBSYSTEM=="usb", ATTR{idVendor}=="2672", ATTR{idProduct}=="000d", ATTR{authorized}="0"
    '';
    udisks2.enable = true;
    upower.enable = true;
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
      fira-code
      fira-code-symbols
      font-awesome
      inconsolata
      iosevka
      jetbrains-mono
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
    extraGroups = [
      "wheel"
      "audio"
      "video"
      "docker"
      "podman"
      "vboxusers"
      "networkmanager"
      "scanner"
      "lp"
    ];
    shell = pkgs.zsh;
  };

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
      use-xdg-base-directories = true
    '';
  };
}
