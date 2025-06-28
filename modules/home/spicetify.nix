{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (inputs.spicetify-nix.legacyPackages.${pkgs.system}) apps themes extensions;
  cfg = config.apps.spicetify;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.apps.spicetify.enable = lib.mkEnableOption "Spicetify";

  config.programs.spicetify = {
    inherit (cfg) enable;
    theme = lib.mkIf config.isCatppuccinEnabled themes.catppuccin;
    colorScheme = lib.mkIf config.isCatppuccinEnabled "mocha";
    enabledCustomApps = [ apps.lyricsPlus ];
    enabledExtensions = with extensions; [
      adblock
      autoSkipVideo
      betterGenres
      bookmark
      fullAlbumDate
      hidePodcasts
      history
      keyboardShortcut
      loopyLoop
      powerBar
      sectionMarker
      shuffle
      songStats
      trashbin
      volumePercentage
    ];
  };
}
