{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixosLaptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        /home/marc/git/private/linux/nixos/configuration.nix
      ];
    };
  };
}
