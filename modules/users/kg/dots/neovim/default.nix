toplevel@{ inputs, ... }:
{
  den.aspects.kg._.neovim.homeManager = { config, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      vimdiffAlias = true;
      imports = with toplevel.config.flake.modules.nixvim; [
        base
        lsp
        ui

        comments
        git
        leetcode
        markdown
        movement
        no-neck-pain
        telescope
        tex
        treesitter
        trouble
        which-key
        yazi
        zen
      ];

      colorschemes.catppuccin = {
        enable = true;
        lazyLoad.enable = true;
      };

      neovim-dashboard = [
        "  ██  ██  ████████  ████████  ██  ██  ██  ██  "
        "  ██  ██  ██              ██  ██  ██          "
        "  ██  ██  ██████████████████  ██  ██  ██████  "
        "  ██  ██                      ██  ██  ██  ██  "
        "  ██  ██  ██████  ██  ██████████  ██  ██████  "
        "  ██  ██  ██                      ██      ██  "
        "  ██  ██████████  ██  ██████  ██  ██████████  "
        "  ██  ██          ██      ██      ██          "
        "  ██████████  ██████  ██████  ██  ██  ██████  "
        "      ██  ██  ██              ██  ██  ██  ██  "
        "  ██  ██████  ██████  ██████████  ██  ██████  "
        "  ██              ██              ██      ██  "
        "  ██████████████████  ██████████████  ██████  "
        "                                              "
      ];

      keymaps = [
        {
          action = config.lib.nixvim.mkRaw ''
            function()
              vim.cmd("enew")
              vim.bo.buftype = "nofile"
              vim.bo.bufhidden = "hide"
              vim.bo.swapfile = false
            end
          '';
          key = "<leader>sp";
          options.desc = "Scratchpad";
        }
      ];
    };
  };
}
