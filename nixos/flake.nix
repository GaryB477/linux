{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    obsidian-nvim.url = "github:epwalsh/obsidian.nvim";
    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };

  outputs = { self, nixpkgs, nvf, ... }@inputs: {
    nixosConfigurations.nixosLaptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        nvf.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
