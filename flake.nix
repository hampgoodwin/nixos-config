{
  description = "My Systems Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follow = "nixpkgs";
    home-manager.url = "guthub:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follow = "nixpkgs";
  };

  outputs =
    inputs: with inputs; {
      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./configurations/desktop/configuration.nix ];
      };
      nixosConfigurations.ideapad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./configurations/ideapad/configuration.nix ];
      };
    };
}
