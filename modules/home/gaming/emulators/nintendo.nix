{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming.emulators.nintendo;
in
{
  options.gaming.emulators.nintendo.enable = lib.mkEnableOption "Nintendo";

  config.home.packages = lib.optionals cfg.enable (
    with pkgs;
    [
      cemu
      dolphin-emu
      ryujinx-greemdev
    ]
  );
}
