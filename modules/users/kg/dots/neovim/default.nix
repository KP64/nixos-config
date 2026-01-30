toplevel@{ inputs, ... }:
{
  flake.modules.homeManager.users-kg-neovim =
    { config, ... }:
    {
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
          telescope
          no-neck-pain
          treesitter
          trouble
          which-key
          yazi
          zen
        ];

        colorschemes.catppuccin.enable = true;
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
            action =
              config.lib.nixvim.mkRaw # lua
                ''
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
