{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.desktop.waybar;
in
{
  options.desktop.waybar.enable = lib.mkEnableOption "Waybar";

  config.home-manager.users.${username}.programs.waybar = {
    inherit (cfg) enable;
    systemd.enable = true;
  };
}
