{ config, ... }:
{
  flake.modules.nixvim.navigation = {
    imports = with config.flake.modules.nixvim; [
      oil
      telescope
    ];
  };
}
