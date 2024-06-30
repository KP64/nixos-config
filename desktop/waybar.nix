{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.waybar.enable = lib.mkEnableOption "Enables Waybar";

  config = lib.mkIf config.desktop.waybar.enable {
    home-manager.users.${username}.programs.waybar = {
      enable = true;
      systemd.enable = true;
    };
  };
}
