{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:

let
  blender = inputs.blender-bin.packages.${pkgs.system}.default;

  firstTwoSigs = lib.take 2 (builtins.splitVersion blender.version);
  version = lib.concatStringsSep "." firstTwoSigs;
in
{
  options.editors.blender.enable = lib.mkEnableOption "Enable Blender";

  config = lib.mkIf config.editors.blender.enable {
    home-manager.users.${username} = {
      home.packages = [ blender ];
      xdg.configFile."blender/${version}/scripts/presets/interface_theme/mocha_lavender.xml" = {
        source = "${inputs.catppuccin-blender}/themes/mocha_lavender.xml";
      };
    };
  };
}
