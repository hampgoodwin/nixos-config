{
  description = "Mac Configuration";

  inputs = {
    # standard packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

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

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      mac-app-util,
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

            ## programming languages
            ### go
            go_1_23
            gofumpt
            golangci-lint
            gopls
            delve

            ### bash
            shellcheck
            bash-language-server

            ### node
            nodejs_22
            nodePackages.typescript-language-server
            eslint_d

            ### lua
            lua
            luajitPackages.luarocks
            lua-language-server
            stylua
            ### nix
            nix
            nixfmt-rfc-style
            nil

            ## tools
            fd
            eza
            delta
            tlrc
            zoxide
            openssh
            git
            ripgrep
            jq
            fzf

            # applications
            ## efficiency
            ## window manager
            aerospace
            jankyborders # use to highlight active windows more clearly
            ## music
            spotify

            ## communications
            # slack # managed by rippling
            discord
          ];

          # homebrew declarations
          homebrew = {
            enable = true;
            casks = [
              "enpass"
              "firefox"
              "obsidian"
              "notion" # company uses notion
              "focusrite-control-2"
              "linear-linear"
            ];
            # in order for mas apps to install, ensure you're logged into
            # the [m]ac [a]pp [s]tore and have purchased the app.
            #masApps = {};
            onActivation = {
              cleanup = "uninstall";
              autoUpdate = true;
              upgrade = true;
            };
          };

          # fonts
          fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

          # system settings
          system.defaults = {
            dock = {
              autohide = true;
              persistent-apps = [
                "${pkgs.kitty}/Applications/Kitty.app"
                "/Applications/Firefox.app"
                "/Applications/Enpass.app"
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
          system.activationScripts = {
            postUserActivation.text = "defaultbrowser firefox";
          };

          # nix-darwin requires this because determinate and nix-darwin have conflicting
          # managers.
          nix.enable = false;
          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          programs = {
            zsh = {
              enable = true; # default shell on catalina
              enableFzfGit = true;
              enableFzfHistory = true;
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
      # $ darwin-rebuild build --flake .#ghost
      darwinConfigurations."ghost" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true; # default true

              # User owning the homebrew prefix
              user = "hampgoodwin";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };

              # Optional: Enable fully-declarative tap management
              #
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Hamps-MacBook-Air".pkgs;
    };
}
