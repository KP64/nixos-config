{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
    ./hyprsunset.nix
    ./rofi.nix
  ];

  config = lib.mkIf config.desktop.hyprland.enable {
    home.packages = with pkgs; [
      xdg-utils
      libnotify
    ];

    gtk.enable = true;
    qt.enable = true;

    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        createDirectories = true;
      };
    };
  };
}
