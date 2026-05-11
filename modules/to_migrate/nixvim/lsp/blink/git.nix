{
  flake.modules.nixvim.blink-git = {
    plugins = {
      blink-cmp-git.enable = true;
      blink-cmp.settings.sources = {
        default = [ "git" ];
        providers.git = {
          module = "blink-cmp-git";
          name = "Git";
          score_offset = 100;
        };
      };
    };
  };
}
