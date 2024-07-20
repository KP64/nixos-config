{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  tuigreet = lib.getExe pkgs.greetd.tuigreet;
in
{
  options.desktop.login.tuigreet.enable = lib.mkEnableOption "Enables TuiGreet";

  config = lib.mkIf config.desktop.login.tuigreet.enable {
    services.greetd = {
      enable = true;
      settings.default_session = {
        command = "${tuigreet} --time --cmd hyprland";
        user = username;
      };
    };
  };
}
