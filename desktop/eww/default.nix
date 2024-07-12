{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.desktop.eww.enable = lib.mkEnableOption "Enables eww";

  config = lib.mkIf config.desktop.eww.enable {
    services.playerctld.enable = true;
    home-manager.users.${username}.programs.eww = {
      enable = true;
      package = inputs.eww.packages.${pkgs.system}.eww;
      configDir = ./conf;
    };
  };
}
