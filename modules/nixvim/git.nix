{
  flake.modules.nixvim.git =
    { lib, ... }:
    {
      dependencies.git = {
        enable = true;
        packageFallback = true;
      };

      plugins = {
        fugitive.enable = true;
        gitsigns = {
          enable = true;
          lazyLoad.settings.event = "DeferredUIEnter";
          settings.current_line_blame = true;
        };
      };

      keymaps =
        (map
          (
            { key, value }:
            {
              mode = "n";
              inherit key;
              action =
                lib.nixvim.mkRaw # lua
                  ''
                    function()
                      if vim.wo.diff then
                        vim.cmd.normal({'${key}', bang = true})
                      else
                        require('gitsigns').nav_hunk('${value}')
                      end
                    end
                  '';
            }
          )
          [
            {
              key = "]c";
              value = "next";
            }
            {
              key = "[c";
              value = "prev";
            }
          ]
        )
        ++ [
          {
            mode = "n";
            key = "<leader>hs";
            action = "<CMD>Gitsigns stage_hunk<CR>";
          }
          {
            mode = "n";
            key = "<leader>hr";
            action = "<CMD>Gitsigns reset_hunk<CR>";
          }
          {
            mode = "v";
            key = "<leader>hs";
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                  end
                '';
          }
          {
            mode = "v";
            key = "<leader>hr";
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
                  end
                '';
          }
          {
            mode = "n";
            key = "<leader>hS";
            action = "<CMD>Gitsigns stage_buffer<CR>";
          }
          {
            mode = "n";
            key = "<leader>hR";
            action = "<CMD>Gitsigns reset_buffer<CR>";
          }
          {
            mode = "n";
            key = "<leader>hp";
            action = "<CMD>Gitsigns preview_hunk<CR>";
          }
          {
            mode = "n";
            key = "<leader>hi";
            action = "<CMD>Gitsigns preview_hunk_inline<CR>";
          }
          {
            mode = "n";
            key = "<leader>hb";
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    require('gitsigns').blame_line({ full = true })
                  end
                '';
          }
          {
            mode = "n";
            key = "<leader>hd";
            action = "<CMD>Gitsigns diffthis<CR>";
          }
          {
            mode = "n";
            key = "<leader>hD";
            action =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    require('gitsigns').diffthis('~')
                  end
                '';
          }
          {
            mode = "n";
            key = "<leader>hq";
            action = "<CMD>Gitsigns setqflist<CR>";
          }
          {
            mode = "n";
            key = "<leader>tb";
            action = "<CMD>Gitsigns toggle_current_line_blame<CR>";
          }
          {
            mode = "n";
            key = "<leader>tw";
            action = "<CMD>Gitsigns toggle_word_diff<CR>";
          }
          {
            mode = [
              "o"
              "x"
            ];
            key = "ih";
            action = "<CMD>Gitsigns select_hunk<CR>";
          }
        ];
    };
}
