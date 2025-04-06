{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  cfg = config.apps.spicetify;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.apps.spicetify.enable = lib.mkEnableOption "Spicetify";

  config.programs.spicetify = {
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
}
