{ config, ... }:
{
  flake.modules.nixvim.ui = {
    imports = with config.flake.modules.nixvim; [
      bufferline
      dashboard
      highlight-colors
      hlchunk
      lualine
      modicator
      noice
      tiny-inline-diagnostic
    ];

    # TODO: Add colorful-winsep
    plugins.rainbow-delimiters.enable = true;
  };
}
