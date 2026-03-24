{
  self,
  pkgs,
  pkgs-stable-darwin,
  ...
}:
{
  users.users = {
    hamp = {
      shell = pkgs.zsh;
      description = "Hamp Goodwin";
      home = "/Users/hamp";
    };
  };
  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # terminal emulator
    kitty
    ## text editors
    neovim
    obsidian

    ### lua
    lua
    luajitPackages.luarocks
    lua-language-server
    stylua
    ### nix
    nixfmt-rfc-style
    nixd

    ## tools
    git
    fd
    zoxide

    # applications
    vesktop
    slack
    zoom-us
    gemini-cli
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
