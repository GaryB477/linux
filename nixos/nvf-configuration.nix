{ config, lib, pkgs, modulesPath, ... }:

{
        vim.theme.enabdle = true;
        vim.theme.name = "gruvbox";
        vim.theme.style = "bright";

        vim.languages.nix.enable = true;
}
