{ lib, config, ... }:
{
  imports = [
    ./cemu.nix
    ./dolphin.nix
    ./ryujinx.nix
    ./xemu.nix
  ];

  options.gaming.emulators.enable = lib.mkEnableOption "All Gaming Emulators";

  config.gaming.emulators = lib.mkIf config.gaming.emulators.enable {
    cemu.enable = lib.mkDefault true;
    dolphin.enable = lib.mkDefault true;
    ryujinx.enable = lib.mkDefault true;
    xemu.enable = lib.mkDefault true;
  };
}
