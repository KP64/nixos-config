{ config, ... }:
{
  # TODO: Add oil.nvim (Useful for users with unconfigured yazi)
  # TODO: Make oil.nvim new default on package but not on user kg
  flake.modules.nixvim.navigation = {
    imports = with config.flake.modules.nixvim; [
      telescope
      yazi
    ];
  };
}
