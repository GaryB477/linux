{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgsunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nix-alien.url = "github:thiagokokada/nix-alien";

  };

  outputs = { self, nixpkgs, nvf, ... }@inputs: {
    nixosConfigurations = {
      work_dg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configurations/configuration_work_dg.nix
          nvf.nixosModules.default
        ];
      };
    };
  };
}
