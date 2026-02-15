{ config, ... }:
{
  flake.aspects.markdown.nixvim = {
    imports = with config.flake.modules.nixvim; [
      image
      render-markdown
    ];
  };
}
