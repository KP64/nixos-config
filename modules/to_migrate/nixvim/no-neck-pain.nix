{
  flake.modules.nixvim.no-neck-pain =
    let
      keymap = "<leader>nn";
      cmd = "NoNeckPain";
    in
    {
      plugins.no-neck-pain = {
        enable = true;
        lazyLoad.settings = {
          inherit cmd;
          keys = [ keymap ];
        };
      };

      keymaps = [
        {
          mode = "n";
          key = keymap;
          action = "<CMD>${cmd}<CR>";
          options.desc = "No-Neck-Pain";
        }
      ];
    };
}
