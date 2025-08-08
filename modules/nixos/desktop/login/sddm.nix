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
  options.desktop.login.sddm = {
    enable = lib.mkEnableOption "SDDM";

    background = lib.mkOption {
      default = null;
      type = with lib.types; nullOr path;
      description = "The background that is applied to SDDM (only).";
    };
  };

  config = lib.mkMerge [
    {
      services.displayManager.sddm = {
        inherit (cfg) enable;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
    }

    (lib.mkIf (config.catppuccin.enable && cfg.background != null) {
      catppuccin.sddm = { inherit (cfg) background; };
    })
  ];
}
