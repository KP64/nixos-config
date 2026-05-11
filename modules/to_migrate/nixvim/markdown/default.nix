{ config, ... }:
{
  flake.modules.nixvim.markdown = {
    imports = with config.flake.modules.nixvim; [
      image
      render-markdown
    ];
  };
}
