{ config, lib, ... }:
let
  cfg = config.terminals.kitty;
in
{
  options.terminals.kitty.enable = lib.mkEnableOption "Kitty";

  config.programs.kitty = {
    inherit (cfg) enable;
    font.name = lib.mkDefault "JetBrainsMono Nerd Font";
    settings = {
      shell = lib.mkIf config.programs.nushell.enable "nu";
      background_opacity = lib.mkDefault 0.9;
    };
  };
}
