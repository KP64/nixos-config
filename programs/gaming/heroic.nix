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
      home.packages = with pkgs; [ heroic ];

      xdg.configFile."heroic/themes" = {
        source = inputs.heroic-catppuccin + "/themes/";
        recursive = true;
      };
    };
  };
}
