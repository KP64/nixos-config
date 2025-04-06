{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.emulators.playstation;
in
{
  options.gaming.emulators.playstation.enable = lib.mkEnableOption "Playstation";

  config.home.packages = lib.optionals cfg.enable (
    with pkgs;
    [
      pcsx2
      rpcs3
      shadps4
    ]
  );
}
