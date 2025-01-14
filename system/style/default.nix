{ config, lib, ... }:
{
  imports = [
    ./catppuccin.nix
    ./stylix.nix
  ];

  options.system.fontName = lib.mkOption {
    internal = true;
    type = lib.types.nonEmptyStr;
    default =
      if config.system.style.stylix.enable then
        config.stylix.fonts.monospace.name
      else
        "JetBrainsMono Nerd Font";
  };
}
