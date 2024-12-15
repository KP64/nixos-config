{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.apps.defaults;
in
{
  imports = [
    ./browsers
    ./cli
    ./editors
    ./gaming
    ./virtualisation

    ./mpv.nix
    ./obs.nix
    ./spicetify.nix
    ./thunderbird.nix
  ];

  options.apps.defaults.enable = lib.mkEnableOption "Some Graphical Apps";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username}.home.packages = with pkgs; [
        gimp
        figma-linux

        libreoffice
        hunspell
        hunspellDicts.en_US
        hunspellDicts.de_DE

        anki-bin

        whatsapp-for-linux
        simplex-chat-desktop
        signal-desktop

        czkawka
        lmms
      ];

    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable (
        [ ".cache/whatsapp-for-linux" ]
        ++ (map (p: ".local/share/${p}") [
          "simplex"
          "whatsapp-for-linux"
        ])
        ++ (map (p: ".config/${p}") [
          "libreoffice"
          "Signal"
          "simplex"
          "whatsapp-for-linux"
        ])
      );
    })
  ];
}
