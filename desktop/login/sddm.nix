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

  # TODO: Config for when Catppuccin isn't enabled!!!
  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        catppuccin = {
          background = ../wallpapers/cat-nix.png;
          font = "JetBrainsMono Nerd Font";
        };
        package = pkgs.kdePackages.sddm;
      };
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/sddm";
    })
  ];
}
