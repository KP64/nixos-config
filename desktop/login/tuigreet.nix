{
  pkgs,
  lib,
  config,
  username,
  ...
}:

let
  cfg = config.desktop.login.tuigreet;
  tuigreet = lib.getExe pkgs.greetd.tuigreet;
in
{
  options.desktop.login.tuigreet.enable = lib.mkEnableOption "TuiGreet";

  config.services.greetd = {
    inherit (cfg) enable;
    settings.default_session = {
      command = "${tuigreet} --time";
      user = username;
    };
  };
}
