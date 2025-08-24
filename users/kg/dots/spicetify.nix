{ inputs', ... }:
let
  inherit (inputs'.spicetify-nix.legacyPackages) apps themes extensions;
in
{
  programs.spicetify = {
    enable = true;
    wayland = true; # or null -> depends on NIXOS_OZONE_WL env
    theme = themes.catppuccin;
    colorScheme = "mocha";
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
