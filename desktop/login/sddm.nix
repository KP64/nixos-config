{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.desktop.login.sddm;
in
{
  options.desktop.login.sddm.enable = lib.mkEnableOption "SDDM";

  # TODO: Config for when Catppuccin isn't enabled
  config = lib.mkMerge [
    {
      catppuccin.sddm = {
        background = ../wallpapers/cat-nix.png;
        font = "JetBrainsMono Nerd Font";
      };

      services.displayManager.sddm = {
        inherit (cfg) enable;
        wayland.enable = true;
        package = pkgs.kdePackages.sddm;
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/sddm";
    })
  ];
}
