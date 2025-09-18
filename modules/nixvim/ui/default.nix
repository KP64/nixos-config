{
  flake.modules.nixvim.ui =
    { lib, ... }:
    {
      plugins = {
        bufferline = {
          enable = true;
          settings.options.numbers =
            lib.nixvim.mkRaw # lua
              ''
                function(opts)
                    return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
                end
              '';
        };

        hlchunk = {
          enable = true;
          lazyLoad.settings.event = [
            "BufNewFile"
            "BufReadPost"
          ];
          settings.indent.enable = true;
        };

        lualine = {
          enable = true;
          lazyLoad.settings.event = "DeferredUIEnter";
        };

        rainbow-delimiters.enable = true;

        tiny-inline-diagnostic = {
          enable = true;
          lazyLoad.settings.event = "LspAttach";
        };

        which-key = {
          enable = true;
          lazyLoad.settings.event = "DeferredUIEnter";
          settings.preset = "helix";
        };
      };
    };
}
