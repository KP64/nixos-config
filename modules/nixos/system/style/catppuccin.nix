{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.style.catppuccin;
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

  options.system.style.catppuccin = {
    enable = lib.mkEnableOption "Catppuccin";

    accent = lib.mkOption {
      default = "lavender";
      type = lib.types.nonEmptyStr;
      example = "rosewater";
    };
  };

  config.catppuccin = {
    inherit (cfg) enable accent;
    cache.enable = true;
  };
}
