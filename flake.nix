{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.fh.url = "github:DeterminateSystems/fh";
  # instead of using fh's nixpkgs (dependencies) we can inform it to follow
  # nixpkgs to reduce closure size; this means that if a package at a version
  # exists in both fh and nixpkgs, fh inputs are instructed to follow nixpkgs
  # builds vs created its own
  inputs.fh.inputs.nixpkgs.follows = "nixpkgs";
  # if I want to get into hm we can enable this to get started
  # inputs.home-manager.url = github:nix-community/home-manager;
  # inputs.home-manager.nixpkgs.follows = "nixpkgs"; 

  outputs =
    inputs: with inputs; {
      nixosConfigurations.hamp = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./configuration.nix ];
      };
      nixosConfigurations.latitude-7400 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [ ./configuration-latitude-7400.nix ];
      };
    };
}
