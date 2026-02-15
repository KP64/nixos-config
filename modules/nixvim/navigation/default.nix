{ config, ... }:
{
  flake.aspects.navigation.nixvim = {
    imports = with config.flake.modules.nixvim; [
      oil
      telescope
    ];
  };
}
