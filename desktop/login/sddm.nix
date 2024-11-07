{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.desktop.login.sddm.enable = lib.mkEnableOption "Enables sddm";

  config = lib.mkIf config.desktop.login.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      catppuccin = {
        background = ../wallpapers/cat-nix.png;
        font = "JetBrainsMono Nerd Font";
      };
      package = pkgs.kdePackages.sddm;
    };
    environment.persistence."/persist".directories = [ "/var/lib/sddm" ];
  };
}
