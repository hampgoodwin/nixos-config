{
  description = "My Systems Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
