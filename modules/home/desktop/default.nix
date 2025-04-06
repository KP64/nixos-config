{ pkgs, ... }:
{
  imports = [
    ./copyq.nix
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
    ./mako.nix
    ./rofi.nix
  ];

  # TODO: Check whether actually needed
  # TODO: Only enable all of them if hyprpanel is enabled
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
}
