{
  flake.modules.nixvim.blink-emoji = {
    plugins = {
      blink-emoji.enable = true;
      blink-cmp.settings.sources = {
        default = [ "emoji" ];
        providers.emoji = {
          module = "blink-emoji";
          name = "Emoji";
          score_offset = 15;
          opts.insert = true;
        };
      };
    };
  };
}
