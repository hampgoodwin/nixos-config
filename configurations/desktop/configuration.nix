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
    # ../../modules/sunshine.nix
    ../../modules/developer.nix
    ../../modules/screencapture.nix
  ];

  # Bootloader.
  boot.kernelPackages = pkgs-stable.linuxPackages_6_18;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Addtl Hardware configuration
  hardware.amdgpu.overdrive.enable = true;

  ## filesystems generated at start; prefer disko next time!
  ### this means using disko during nixos installation in gui
  ### or in cli. So next time before a reinstall plan to use
  ### disko and nixos installer, and then use facter.
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f8db41bd-3919-4324-9f71-7457559f3ddf";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E49E-D39F";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/d46e9fee-3667-4b54-a2f2-4422a628280e"; }
  ];

  # Shell, uses zsh
  # from import
  sh.enable = true;
  # h use from import
  user = {
    enable = true;
    name = "h";
  };
  # Audio from import
  audio = {
    enable = true;
    bluetooth.enable = true;
    packages.enable = true;
    lowLatency.enable = true;
    recordingSuite.enable = false;
  };
  developer.enable = true;
  screencapture.enable = true;

  networking.hostName = "h"; # Define your hostname.

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
  environment.systemPackages = with pkgs; [
    # utilities
    util-linux
    usbutils
    xfce.thunar
    unzip
    wl-clipboard
    swappy
    ## security
    enpass
    nettools
    # communication
    firefox
    slack
    vesktop
    obsidian
    # display, window, etc...
    ## bar
    waybar
    waybar-mpris
    ## notifications
    dunst
    libnotify
    ## launcher
    rofi
  ];

  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  services = {
    sunshine = {
      enabled = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
