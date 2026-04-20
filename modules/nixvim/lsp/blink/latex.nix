{
  flake.modules.nixvim.blink-latex = {
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
