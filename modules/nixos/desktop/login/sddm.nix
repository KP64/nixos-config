{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.desktop.login.sddm;
in
{
  options.desktop.login.sddm.enable = lib.mkEnableOption "SDDM";

  config.services.displayManager.sddm = {
    inherit (cfg) enable;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
  };
}
