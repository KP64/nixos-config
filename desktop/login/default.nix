{ config, lib, ... }:
let
  cfg = config.desktop.login;
in
{
  imports = [
    ./tuigreet.nix
    ./sddm.nix
  ];

  options.desktop.login.enable = lib.mkEnableOption "Desktop Login";

  config = lib.mkIf cfg.enable {
    desktop.login.tuigreet.enable = lib.mkDefault true;
  };
}
