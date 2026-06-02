{ config, ... }: {
  flake.modules.nixvim.ui = {
    imports = with config.flake.modules.nixvim; [
      blink-indent
      bufferline
      dashboard
      highlight-colors
      lualine
      modicator
      noice
      tiny-inline-diagnostic
    ];
  };
}
