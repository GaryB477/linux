{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgsunstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    nix-alien.url = "github:thiagokokada/nix-alien";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dg-cli.url = "git+ssh://git@github.com/DigitecGalaxus/Dg.Cli?ref=main";
  };

  outputs = { self, nixpkgs, nvf, lanzaboote, ... }@inputs: {
    nixosConfigurations = {
      work_dg = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          lanzaboote.nixosModules.lanzaboote

          ./configurations/configuration_work_dg.nix
          nvf.nixosModules.default
        ];
      };
    };

    nixosConfigurations = {
      home = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./configurations/configuration_home.nix nvf.nixosModules.default ];
      };
    };
    nixosConfigurations = {
      nas = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules =
          [ ./configurations/configuration_nas.nix nvf.nixosModules.default ];
      };
    };
  };
}
