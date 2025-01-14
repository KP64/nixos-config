{ config, lib, ... }:
let
  cfg = config.desktop.hypr;
in
{
  imports = [
    ./hypridle.nix
    ./hyprland.nix
    ./hyprlock.nix
    ./hyprpanel.nix
    ./hyprpaper.nix
  ];

  options.desktop.hypr.enable = lib.mkEnableOption "Hypr";

  config.desktop.hypr = lib.mkIf cfg.enable {
    hypridle.enable = lib.mkDefault true;
    hyprland.enable = lib.mkDefault true;
    hyprlock.enable = lib.mkDefault true;
    hyprpanel.enable = lib.mkDefault true;
    hyprpaper.enable = lib.mkDefault true;
  };
}
