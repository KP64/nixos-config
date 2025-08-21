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

  config.home = lib.mkIf cfg.enable {
    packages = [ inputs.self.packages.${pkgs.system}.neovim ];
    sessionVariables.EDITOR = lib.mkForce "nvim";
  };
}
