{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.editors.neovim;
in
{
  options.editors.neovim.enable = lib.mkEnableOption "Neovim";

  config.home.packages = lib.optional cfg.enable inputs.self.packages.${pkgs.system}.neovim;
}
