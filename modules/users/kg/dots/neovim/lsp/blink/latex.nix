{
  den.aspects.kg.homeManager.programs.nixvim = {
    plugins = {
      blink-cmp-latex.enable = true;
      blink-cmp.settings.sources = {
        default = [ "latex-symbols" ];
        providers.latex-symbols = {
          name = "Latex";
          module = "blink-cmp-latex";
          opts.insert_command = false;
        };
      };
    };
  };
}
