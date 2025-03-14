{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gaming.emulators;
in
{
  imports = [
    ./nintendo.nix
    ./playstation.nix
    ./xbox.nix
  ];

  options.gaming.emulators.enable = lib.mkEnableOption "All Gaming Emulators";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      gaming.emulators = {
        nintendo.enable = lib.mkDefault true;
        playstation.enable = lib.mkDefault true;
        xbox.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optional (
        cfg.enable || cfg.nintendo.enable || cfg.playstation.enable || cfg.xbox.enable
      ) "Games";
    })
  ];
}
