{
  config,
  lib,
  inputs,
  rootPath,
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

    background = lib.mkOption {
      default = "${rootPath}/assets/wallpapers/cat-nix.png";
      type = lib.types.path;
      description = "The background that is applied to SDDM (only).";
    };
  };

  config.catppuccin = {
    inherit (cfg) enable accent;
    cache.enable = true;
    sddm = { inherit (cfg) background; };
  };
}
