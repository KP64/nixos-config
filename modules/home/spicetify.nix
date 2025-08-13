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
    wayland = true; # or null -> depends on NIXOS_OZONE_WL env
    theme = lib.mkIf config.isCatppuccinEnabled themes.catppuccin;
    colorScheme = lib.mkIf config.isCatppuccinEnabled "mocha";
    enabledCustomApps = [ apps.lyricsPlus ];
    enabledExtensions = with extensions; [
      # Official
      autoSkipVideo
      bookmark
      keyboardShortcut
      loopyLoop
      shuffle
      trashbin

      # Community
      adblock
      betterGenres
      fullAlbumDate
      hidePodcasts
      history
      powerBar
      sectionMarker
      songStats
      volumePercentage
    ];
  };
}
