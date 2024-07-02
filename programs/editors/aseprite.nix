{
  pkgs,
  lib,
  config,
  username,
  inputs,
  ...
}:
{
  options.editors.aseprite.enable = lib.mkEnableOption "Enable Aseprite";

  config = lib.mkIf config.editors.aseprite.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [ aseprite ];
      xdg.configFile."aseprite/extensions/catppuccin-theme-mocha" = {
        source = inputs.aseprite-catppuccin + "/themes/mocha/catppuccin-theme-mocha";
        recursive = true;
      };
    };
  };
}
