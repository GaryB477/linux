{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        # General
        viAlias = false;
        vimAlias = true;
        useSystemClipboard = true;
        searchCase = "ignore";

        # Themes
        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
        };

        # Languages
        lsp.formatOnSave = true;
        languages = {
          enableLSP = true;
          enableTreesitter = true;
          enableFormat = true;

          nix.enable = true;
          bash.enable = true;
          #clang.enable = true;
          #csharp.enable = true;
          #ts.enable = true;
          #markdown.enable = true;
          zig.enable = true;
        };

        # Plugins
        statusline.lualine.enable = true;
        telescope.enable = true;
        autocomplete.nvim-cmp.enable = true;
      };
    };
  };
}
