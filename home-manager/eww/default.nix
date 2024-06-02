{ inputs, pkgs, ... }:
{
  # TODO: Configs are "Borrowed". Make own Config Files ASAP.
  home.packages = with inputs; [ eww.packages.${pkgs.system}.eww ];
  xdg.configFile = {
    "eww/eww.yuck".source = ./eww.yuck;
    "eww/eww.scss".source = ./eww.scss;
  };
}
