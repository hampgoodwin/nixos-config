# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  pkgs,
  pkgs-stable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix # using nixos-facter
    # third-party non-core
    # local import
    ../../modules/audio.nix
    ../../modules/sh.nix
    ../../modules/hamp.nix
    ../../modules/hypr.nix
    ../../modules/steam.nix
    # ./sunshine.nix
    ../../modules/developer.nix
    ../../modules/screencapture.nix
  ];

  # Bootloader.
  boot.kernelPackages = pkgs-stable.linuxPackages_6_12;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  ## filesystems generated at start; prefer disko next time!
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/5e27d6c5-103b-48c2-9b08-9b6d7d61913e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/479E-CC2E";
    fsType = "vfat";
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/8244c73d-f20c-4ae3-8fe6-eeebc3d51c5f"; }
  ];

  # Shell, uses zsh
  # from import
  sh.enable = true;
  # hamp use from import
  user = {
    enable = true;
    name = "hamp";
  };
  # Audio from import
  audio = {
    enable = true;
    bluetooth.enable = true;
    packages.enable = true;
    lowLatency.enable = true;
    recordingSuite.enable = true;
  };
  developer.enable = true;
  screencapture.enable = true;

  networking.hostName = "hamp"; # Define your hostname.

  # Enable wireless networking/lan via network manager
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Denver";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services = {
    ollama = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      acceleration = "rocm";
      rocmOverrideGfx = "11.0.0";
      environmentVariables = {
        OLLAMA_KEEP_ALIVE = "5m";
      };
    };
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
      port = 8081;
      environment = {
        OLLAMA_API_BASE_URL = "http://hamp:11434";
        WEBUI_AUTH = "False";
      };
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable flakes and accompanying nix cli tools
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  # List packages installed in system profile. To search, run:
  environment.systemPackages = [
    # keyboard
    # keymapp # doesn't work
    # zsa-udev-rules # doesn't work; add custom udev rules?
    # utilities
    pkgs.util-linux
    pkgs.usbutils
    pkgs.xfce.thunar
    pkgs.orca-slicer
    pkgs.unzip
    pkgs.wl-clipboard
    pkgs.swappy
    pkgs.nixos-facter
    ## security
    pkgs.enpass
    pkgs.nettools
    # communication
    pkgs.firefox
    pkgs.slack
    pkgs.vesktop
    pkgs.obsidian
    # bar
    pkgs.waybar
    pkgs.waybar-mpris
    # widgets
    # notifications
    pkgs.dunst
    pkgs.libnotify
    # launcher
    pkgs.rofi
    # music
    pkgs.spotify
    # video
    pkgs.obs-studio
    # image
    pkgs-stable.gimp-with-plugins
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # virtualization gui manager
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "hamp" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    # enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
