{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgsunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgsunstable,
    nvf,
    ...
  } @ inputs: {
    nixosConfigurations = {
      work_dg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nvf.nixosModules.default
          ./configurations/configuration_work_dg.nix
        ];
        #specialArgs = nixpkgsunstable;
      };
    };
  };
}
