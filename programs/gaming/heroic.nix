{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:
let
  cfg = config.gaming.heroic;
in
{
  options.gaming.heroic.enable = lib.mkEnableOption "Heroic";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        home.packages = [ pkgs.heroic ];

        xdg.configFile."heroic/themes" = {
          source = "${inputs.catppuccin-heroic}/themes/";
          recursive = true;
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories =
        lib.optional cfg.enable ".config/heroic";
    })
  ];
}
