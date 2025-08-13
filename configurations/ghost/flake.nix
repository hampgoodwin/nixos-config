{
  description = "Mac Configuration";

  inputs = {
    # standard packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
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
            # network tools
            wget

            # developer toolings
            ## terminal emulator
            kitty
            zellij

            ## text editors
            vim
            bat
            neovim

            ## datastores
            postgresql_17

            ## programming languages
            ### infra
            tenv # opentofu, terraform, terrafrunt ,and atmos version manager
            terraform-ls # terraform language server
            ### vscode language servers
            vscode-langservers-extracted
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
            typescript
            # vtsls
            typescript-language-server
            # typescript-go
            eslint_d
            prettierd
            vscode-js-debug

            ### lua
            lua
            luajitPackages.luarocks
            lua-language-server
            stylua
            ### nix
            nixfmt-rfc-style
            nil

            ## tools
            fd
            gawk
            gnupg
            eza
            delta
            tlrc
            zoxide
            openssh
            git
            ripgrep
            jq
            jd-diff-patch
            fzf
            postman
            magic-wormhole
            imagemagick
            lazygit
            graphviz # for madge to make graphs of deps
            natscli
            direnv
            nix-direnv

            # applications
            ## efficiency
            ## window manager
            aerospace
            jankyborders # use to highlight active windows more clearly
            ## music
            spotify

            ## communications
            # slack # managed by rippling
            # discord
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
            NSGlobalDomain._HIHideMenuBar = true;
          };
          # unfortunately, there's no module because uninstalling rosetta 2
          # is a challenge. https://github.com/LnL7/nix-darwin/issues/786
          system.activationScripts.extraActivation.text = ''
            softwareupdate --install-rosetta --agree-to-license
          '';

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
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."ghost".pkgs;
    };
}
