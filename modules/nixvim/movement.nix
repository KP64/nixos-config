{
  flake.modules.nixvim.movement =
    { lib, ... }:
    {
      plugins = {
        hardtime.enable = true;
        spider = {
          enable = true;
          keymaps = {
            silent = true;
            motions = lib.genAttrs [ "b" "e" "ge" "w" ] (name: name);
          };
        };

        nvim-surround = {
          enable = true;
          lazyLoad.settings.event = "DeferredUIEnter";
        };

        flash = {
          enable = true;
          lazyLoad.settings.event = "DeferredUIEnter";
        };
      };

      keymaps = [
        {
          key = "s";
          mode = [
            "n"
            "x"
            "o"
          ];
          action =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  require("flash").jump()
                end
              '';
          options.desc = "Flash";
        }
        {
          key = "S";
          mode = [
            "n"
            "x"
            "o"
          ];
          action =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  require("flash").treesitter()
                end
              '';
          options.desc = "Flash Treesitter";
        }
        {
          key = "r";
          mode = [ "o" ];
          action =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  require("flash").remote()
                end
              '';
          options.desc = "Remote Flash";
        }
        {
          key = "R";
          mode = [
            "o"
            "x"
          ];
          action =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  require("flash").treesitter_search()
                end
              '';
          options.desc = "Treesitter Search";
        }
        {
          key = "<c-s>";
          mode = [ "c" ];
          action =
            lib.nixvim.mkRaw # lua
              ''
                function()
                  require("flash").toggle()
                end
              '';
          options.desc = "Toggle Flash Search";
        }
      ];
    };
}
