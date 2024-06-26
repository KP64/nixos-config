{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.login.tuigreet.enable = lib.mkEnableOption "Enables TuiGreet";

  # TODO: The cmd is wrong when hyprland is not enabled
  config = lib.mkIf config.desktop.login.tuigreet.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd hyprland";
        user = username;
      };
    };
  };
}
