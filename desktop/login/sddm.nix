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
        background = builtins.toString ../wallpapers/nix-wp-cat-mocha.png;
        font = "JetBrainsMono Nerd Font";
      };
      package = pkgs.kdePackages.sddm;
    };
  };
}
