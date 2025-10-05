{
  flake.modules.nixvim.git = {
    # TODO: Keybinds
    plugins = {
      fugitive.enable = true;
      git-conflict.enable = true;
      gitsigns = {
        enable = true;
        lazyLoad.settings.event = "DeferredUIEnter";
        settings.current_line_blame = true;
      };
    };
  };
}
