{
  flake.modules.nixvim.zen =
    { lib, ... }:
    let
      zenModeKeymap = "<leader>zn";
      zenModeCmd = "ZenMode";
    in
    {
      plugins = {
        twilight = {
          enable = true;
          lazyLoad.settings.cmd = "Twilight";
        };
        no-neck-pain = {
          enable = true;
          lazyLoad.settings.cmd = "NoNeckPain";
        };
        zen-mode = {
          enable = true;
          lazyLoad.settings = {
            cmd = zenModeCmd;
            keys = [ zenModeKeymap ];
            before =
              lib.nixvim.mkRaw # lua
                ''
                  function()
                    require("lz.n").trigger_load("twilight.nvim")
                    require("lz.n").trigger_load("no-neck-pain.nvim")
                  end
                '';
          };
        };
      };

      keymaps = [
        {
          mode = "n";
          key = zenModeKeymap;
          action = "<CMD>${zenModeCmd}<CR>";
          options.desc = "Zen Mode";
        }
      ];
    };
}
