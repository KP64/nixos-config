{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming.emulators.cemu;
in
{
  options.gaming.emulators.cemu.enable = lib.mkEnableOption "Cemu";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable { home-manager.users.${username}.home.packages = [ pkgs.cemu ]; })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories =
        lib.optional cfg.enable ".config/Cemu";
    })
  ];
}
