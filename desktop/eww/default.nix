{
  lib,
  config,
  username,
  ...
}:
{
  options.desktop.eww.enable = lib.mkEnableOption "EWW";

  config = lib.mkIf config.desktop.eww.enable {
    services.playerctld.enable = true;
    home-manager.users.${username}.programs.eww = {
      enable = true;
      configDir = ./conf;
    };
  };
}
