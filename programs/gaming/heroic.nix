{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.gaming.heroic.enable = lib.mkEnableOption "Enables The Heroic Game Launcher";

  config = lib.mkIf config.gaming.heroic.enable {
    home-manager.users.${username} = {
      home.packages = [ pkgs.heroic ];

      xdg.configFile."heroic/themes" = {
        source = "${inputs.catppuccin-heroic}/themes/";
        recursive = true;
      };
    };
  };
}
