{
  self,
  pkgs,
  pkgs-stable,
  ...
}:
{
  # users
  users.users = {
    hampgoodwin = {
      shell = pkgs.zsh;
      description = "Hamp Goodwin";
      home = "/Users/hampgoodwin";
    };
  };

  # allow unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    # global user space
    git
    openssh
    fzf
    ripgrep
    jq

    # developer toolings
    ## terminal emulator
    kitty
    # ghostty # busted on aarch64-darwin ;(
    zellij

    ## text editors
    vim
    bat
    neovim

    ### lua
    lua
    luajitPackages.luarocks
    lua-language-server
    stylua
    ### nix
    nixfmt-rfc-style
    nixd

    ## tools
    fd
    zoxide

    # applications
    firefox
    spotify
    slack
    ## security
    #wireguard # install gui in mac via appstore
    #enpass # install gui in mac via appstore
    ## efficiency
    ## window manager
    aerospace
    jankyborders # use to highlight active windows more clearly
  ];

  # fonts
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  # system settings
  system.primaryUser = "hampgoodwin";
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

  # i use determinate nix which manages nix
  nix.enable = false;

  programs = {
    zsh = {
      enable = true; # default shell on catalina
      enableFzfGit = true;
      enableFzfHistory = true;
    };
    direnv = {
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
  };

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
