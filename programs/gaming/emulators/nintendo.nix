{
  lib,
  config,
  pkgs,
  stable-pkgs,
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
      home-manager.users.${username}.home.packages =
        [ stable-pkgs.dolphin-emu ]
        ++ (with pkgs; [
          cemu
          ryujinx-greemdev
        ]);
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories =
        lib.optional cfg.enable ".config/Cemu";
    })
  ];
}
