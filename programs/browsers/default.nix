{ config, lib, ... }:
let
  cfg = config.browsers;
in
{
  imports = [
    ./firefox
    ./tor.nix
  ];

  options.browsers.enable = lib.mkEnableOption "Browsers";

  config.browsers = lib.mkIf cfg.enable {
    firefox.enable = lib.mkDefault true;
    tor.enable = lib.mkDefault true;
  };
}
