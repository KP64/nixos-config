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
    # TODO: Configs are "Borrowed". Make own Config Files ASAP.
    home-manager.users.${username} = {
      home.packages = with inputs; [ eww.packages.${pkgs.system}.eww ];
      xdg.configFile = {
        "eww/eww.yuck".source = ./eww.yuck;
        "eww/eww.scss".source = ./eww.scss;
      };
    };
  };
}
