{ config, ... }:
{
  flake.modules.nixvim.navigation = {
    imports = with config.flake.modules.nixvim; [
      telescope
      yazi
    ];
  };
}
