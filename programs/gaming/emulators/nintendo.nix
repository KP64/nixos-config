{
  lib,
  config,
  pkgs,
  username,
  ...
}:
let
  cfg = config.gaming.emulators.nintendo;
in
{
  options.gaming.emulators.nintendo.enable = lib.mkEnableOption "Nintendo";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username}.home.packages = with pkgs; [
        cemu
        dolphin-emu
        ryujinx-greemdev
      ];
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable (
        map (p: ".config/${p}") [
          "Cemu"
          "dolphin-emu"
        ]
      );
    })
  ];
}
