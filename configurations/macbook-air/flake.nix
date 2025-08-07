{
  description = "Mac Configuration";

  inputs = {
    # standard packages
    # Use `github:NixOS/nixpkgs/nixpkgs-25.05-darwin` to use Nixpkgs 25.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-25.05` to use Nixpkgs 25.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # # third party
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      configuration =
        { pkgs, config, ... }:
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

            # osx alias mk tool for nix
            mkalias

            # darwin tools
            defaultbrowser

            # developer toolings
            ## terminal emulator
            kitty
            zellij

            ## text editors
            vim
            bat
            neovim

            ### node
            nodejs_22
            typescript-language-server
            eslint_d

            ### lua
            lua
            luajitPackages.luarocks
            lua-language-server
            stylua
            ### nix
            nix
            nixfmt-rfc-style
            nixd

            ## tools
            fd
            eza
            delta
            tlrc
            zoxide

            # applications
            ## efficiency
            ## window manager
            aerospace
            jankyborders # use to highlight active windows more clearly
            ## music
            spotify

            ## communications
            firefox-unwrapped
            enpass-mac
            slack
            discord
          ];

          # fonts
          fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

          # system settings
          system.primaryUser = "hampgoodwin";
          system.defaults = {
            dock = {
              autohide = true;
              persistent-apps = [
                "${pkgs.kitty}/Applications/Kitty.app"
                "${pkgs.firefox-unwrapped}/Applications/Firefox.app"
                "${pkgs.enpass-mac}/Applications/Enpass.app"
              ];
            };
            finder = {
              AppleShowAllExtensions = true;
              ShowPathbar = true;
              FXPreferredViewStyle = "clmv";
            };
            loginwindow.GuestEnabled = false;
            NSGlobalDomain.AppleICUForce24HourTime = false;
          };
          # unfortunately, there's no module because uninstalling rosetta 2
          # is a challenge. https://github.com/LnL7/nix-darwin/issues/786
          system.activationScripts.extraActivation.text = ''
            softwareupdate --install-rosetta --agree-to-license
          '';

          # Auto upgrade nix package and the daemon service.
          nix.enable = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          programs = {
            zsh = {
              enable = true; # default shell on catalina
              enableFzfGit = true;
              enableFzfHistory = true;
            };
            direnv = {
              enable = true;
              silent = false;
              loadInNixShell = true;
              # enableZshIntegration = true;
              nix-direnv = {
                enable = true;
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
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Hamps-MacBook-Air
      darwinConfigurations."Hamps-MacBook-Air" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # manager hampgoodwin user
            home-manager.users.hampgoodwin = {
              imports = [
              ];
              home = {
                username = "hampgoodwin";
                # homeDirectory = "/Users/hampgoodwin";

                stateVersion = "24.05";
              };

              programs.home-manager.enable = true;
            };

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Hamps-MacBook-Air".pkgs;
    };
}
