{
  description = "Hamps Systems <3";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      cachix,
      ...
    }@inputs:
    let
      linux = "x86_64-linux";
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
    };
}
