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
      rainbow-delimiters
      tiny-inline-diagnostic
    ];
  };
}
