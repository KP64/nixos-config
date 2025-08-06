let
  zenModeKeymap = "<leader>zn";
  zenModeCmd = "ZenMode";
in
{
  plugins = {
    # TODO: LazyLoad, such that twilight is loaded before zen-mode
    twilight.enable = true;
    zen-mode = {
      enable = true;
      lazyLoad.settings = {
        cmd = zenModeCmd;
        keys = [ zenModeKeymap ];
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
}
