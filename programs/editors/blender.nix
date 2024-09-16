{
  lib,
  config,
  pkgs,
  inputs,
  username,
  ...
}:

let
  inherit (pkgs) blender;

  firstTwoSigs = lib.take 2 (builtins.splitVersion blender.version);
  version = lib.concatStringsSep "." firstTwoSigs;
in
{
  options.editors.blender.enable = lib.mkEnableOption "Enable Blender";

  config = lib.mkIf config.editors.blender.enable {
    home-manager.users.${username} = {
      home.packages = [ blender ];
      xdg.configFile."blender/${version}/scripts/presets/interface_theme/mocha_lavender.xml" = {
        source = "${inputs.blender-catppuccin}/themes/mocha_lavender.xml";
      };
    };
  };
}
