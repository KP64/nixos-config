{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming.emulators.playstation;
in
{
  options.gaming.emulators.playstation.enable = lib.mkEnableOption "Playstation";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username}.home.packages = with pkgs; [
        pcsx2
        rpcs3
        shadps4
      ];
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        ".config/rpcs3"
        ".cache/rpcs3"
      ];
    })
  ];
}
