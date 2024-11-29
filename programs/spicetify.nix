{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  cfg = config.apps.spicetify;
in
{
  options.apps.spicetify.enable = lib.mkEnableOption "Spicetify";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];
        programs.spicetify = {
          enable = true;
          theme = spicePkgs.themes.catppuccin;
          colorScheme = "mocha";
          enabledCustomApps = [ spicePkgs.apps.lyricsPlus ];
          enabledExtensions = with spicePkgs.extensions; [
            adblock
            autoSkipVideo
            betterGenres
            bookmark
            fullAlbumDate
            hidePodcasts
            history
            keyboardShortcut
            loopyLoop
            popupLyrics
            sectionMarker
            shuffle
            songStats
            trashbin
            volumePercentage
          ];
        };
      };
    })

    (lib.mkIf config.system.impermanence.enable {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        ".config/spotify"
        ".cache/spotify"
      ];
    })
  ];
}
