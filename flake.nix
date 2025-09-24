{
  description = "Hamps Systems <3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    nix-darwin-pkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nix-darwin-pkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      nix-darwin,
      mac-app-util,
      cachix,
      ...
    }@inputs:
    let
      linux = "x86_64-linux";
      darwin = "aarch64-darwin";
      pkgs-stable = import inputs.nixpkgs-stable {
        system = linux;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = linux;
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [
          ./configurations/desktop/configuration.nix
        ];
      };
      nixosConfigurations.ideapad = nixpkgs.lib.nixosSystem {
        system = linux;
        specialArgs = {
          inherit inputs;
          inherit pkgs-stable;
        };
        modules = [ ./configurations/ideapad/configuration.nix ];
      };
      darwinConfigurations.mbp = nix-darwin.lib.darwinSystem {
        system = darwin;
        modules = [
          ./configurations/mbp/configuration.nix
          mac-app-util.darwinModules.default
        ];
        specialArgs = {
          inherit inputs;
          inherit self;
        };
      };

      darwinPackages = self.darwinConfigurations.mbp.pkgs;
    };
}
