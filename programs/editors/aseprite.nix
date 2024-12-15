{
  pkgs,
  lib,
  config,
  username,
  inputs,
  ...
}:
let
  cfg = config.editors.aseprite;
in
{
  options.editors.aseprite.enable = lib.mkEnableOption "Aseprite";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        home.packages = [ pkgs.aseprite ];
        xdg.configFile."aseprite/extensions/catppuccin-theme-mocha" = {
          source = "${inputs.catppuccin-aseprite}/themes/mocha/catppuccin-theme-mocha";
          recursive = true;
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories =
        lib.optional cfg.enable ".config/aseprite/aseprite.ini";
    })
  ];
}
