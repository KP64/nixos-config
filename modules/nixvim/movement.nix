{
  flake.modules.nixvim.movement =
    { lib, ... }:
    let
      lazyLoad.settings.event = "DeferredUIEnter";

      mkFlashRequire =
        func:
        lib.nixvim.mkRaw # lua
          ''
            function()
              require("flash").${func}()
            end
          '';

    in
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
          inherit lazyLoad;
        };

        flash = {
          enable = true;
          inherit lazyLoad;
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
          action = mkFlashRequire "jump";
          options.desc = "Flash";
        }
        {
          key = "S";
          mode = [
            "n"
            "x"
            "o"
          ];
          action = mkFlashRequire "treesitter";
          options.desc = "Flash Treesitter";
        }
        {
          key = "r";
          mode = [ "o" ];
          action = mkFlashRequire "remote";
          options.desc = "Remote Flash";
        }
        {
          key = "R";
          mode = [
            "o"
            "x"
          ];
          action = mkFlashRequire "treesitter_search";
          options.desc = "Treesitter Search";
        }
        {
          key = "<c-s>";
          mode = [ "c" ];
          action = mkFlashRequire "toggle";
          options.desc = "Toggle Flash Search";
        }
      ];
    };
}
