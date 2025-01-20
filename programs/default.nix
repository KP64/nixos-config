{
  config,
  lib,
  pkgs,
  stable-pkgs,
  username,
  ...
}:
let
  cfg = config.apps;
in
{
  imports = [
    ./browsers
    ./cli
    ./editors
    ./file-managers
    ./gaming
    ./terminals
    ./virtualisation

    ./mpv.nix
    ./obs.nix
    ./spicetify.nix
    ./thunderbird.nix
  ];

  options.apps = {
    enable = lib.mkEnableOption "All Programs";
    misc.enable = lib.mkEnableOption "Misc Graphical Apps";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      browsers.enable = lib.mkDefault true;
      cli.enable = lib.mkDefault true;
      editors.enable = lib.mkDefault true;
      file-managers.enable = lib.mkDefault true;
      gaming.enable = lib.mkDefault true;
      terminals.enable = lib.mkDefault true;
      virt.enable = lib.mkDefault true;
      apps = {
        misc.enable = lib.mkDefault true;
        mpv.enable = lib.mkDefault true;
        obs.enable = lib.mkDefault true;
        spicetify.enable = lib.mkDefault true;
        thunderbird.enable = lib.mkDefault true;
      };
    })

    {
      home-manager.users.${username}.home.packages = lib.optionals cfg.misc.enable (
        [ stable-pkgs.gimp-with-plugins ]
        ++ (with pkgs; [
          obsidian

          libreoffice
          hunspell
          hunspellDicts.en_US
          hunspellDicts.de_DE

          anki-bin

          whatsapp-for-linux
          simplex-chat-desktop
          signal-desktop

          czkawka
        ])
      );
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.misc.enable (
        [ ".cache/whatsapp-for-linux" ]
        ++ (map (p: ".local/share/${p}") [
          "simplex"
          "whatsapp-for-linux"
          "wasistlos"
        ])
        ++ (map (p: ".config/${p}") [
          "libreoffice"
          "obsidian"
          "Signal"
          "simplex"
          "whatsapp-for-linux"
          "wasistlos"
        ])
      );
    })
  ];
}
