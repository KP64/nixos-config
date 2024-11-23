{ lib, config, ... }:
{
  imports = [
    ./cemu.nix
    ./dolphin.nix
    ./ryujinx.nix
    ./xemu.nix
  ];

  options.gaming.emulators.enable = lib.mkEnableOption "All Gaming Emulators";

  config = lib.mkIf config.gaming.emulators.enable {
    gaming.emulators = {
      cemu.enable = true;
      dolphin.enable = true;
      ryujinx.enable = true;
      xemu.enable = true;
    };
  };
}
