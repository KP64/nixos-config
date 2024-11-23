{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
{
  options.gaming.heroic.enable = lib.mkEnableOption "Heroic";

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
