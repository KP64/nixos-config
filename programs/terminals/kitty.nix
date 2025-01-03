{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.terminals.kitty;
in
{
  options.terminals.kitty.enable = lib.mkEnableOption "Kitty";

  config.home-manager.users.${username}.programs.kitty = {
    inherit (cfg) enable;
    font.name = config.system.fontName;
    settings = {
      shell = "nu";
      background_opacity = lib.mkIf config.isCatppuccinEnabled "0.8";
    };
  };
}
