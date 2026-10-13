{
  den.aspects.kg.homeManager =
    { config, ... }:
    let
      zenModeKeymap = "<leader>zn";
      zenModeCmd = "ZenMode";
    in
    {
      programs.nixvim = {
        plugins = {
          twilight = {
            enable = true;
            lazyLoad.settings.cmd = "Twilight";
          };
          zen-mode = {
            enable = true;
            lazyLoad.settings = {
              cmd = zenModeCmd;
              keys = [ zenModeKeymap ];
              before = config.lib.nixvim.mkRaw ''
                function()
                  require("lz.n").trigger_load("twilight.nvim")
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
    };
}
