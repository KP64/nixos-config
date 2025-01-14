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
    {
      home-manager.users.${username} = {
        imports = [ inputs.spicetify-nix.homeManagerModules.default ];
        programs.spicetify = {
          inherit (cfg) enable;
          theme = lib.mkIf config.isCatppuccinEnabled spicePkgs.themes.catppuccin;
          colorScheme = lib.mkIf config.isCatppuccinEnabled "mocha";
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
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = lib.optionals cfg.enable [
        ".config/spotify"
        ".cache/spotify"
      ];
    })
  ];
}
