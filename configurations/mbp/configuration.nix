{
  self,
  pkgs,
  pkgs-stable-darwin,
  ...
}:
{
  imports = [
    ../../modules/developer.nix
  ];
  users.users = {
    hamp = {
      shell = pkgs.zsh;
      description = "Hamp Goodwin";
      home = "/Users/hamp";
    };
  };
  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  # developer module
  developer.enable = true;
  developer.ai.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ## text editors
    neovim
    obsidian

    ## tools
    git
    zoxide
    protonmail-desktop

    # applications
    slack
    zoom-us
    ## window manager
    aerospace
    jankyborders # use to highlight active windows more clearly
  ];

  # fonts
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # system settings
  system.primaryUser = "hamp";
  system.defaults = {
    dock = {
      autohide = true;
      persistent-apps = [ ];
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv";
    };
    loginwindow.GuestEnabled = false;
    NSGlobalDomain.AppleICUForce24HourTime = false;
  };
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  # i use determinate nix which manages nix
  nix.enable = false;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
