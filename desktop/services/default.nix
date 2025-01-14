{ config, lib, ... }:
let
  cfg = config.desktop.services;
in
{
  imports = [
    ./blueman-app.nix
    ./copyq.nix
    ./mako.nix
    ./ntwrk-mgr-app.nix
    ./udiskie.nix
  ];

  options.desktop.services.enable = lib.mkEnableOption "Desktop Services";

  config.desktop.services = lib.mkIf cfg.enable {
    blueman-app.enable = lib.mkDefault true;
    copyq.enable = lib.mkDefault true;
    ntwrk-mgr-app.enable = lib.mkDefault true;
    udiskie.enable = lib.mkDefault true;
  };
}
