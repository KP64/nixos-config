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
in
{
  options.apps.spicetify.enable = lib.mkEnableOption "Enables Spicetify";

  config = lib.mkIf config.apps.spicetify.enable {
    home-manager.users.${username} = {
      imports = [ inputs.spicetify-nix.homeManagerModules.default ];
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledCustomApps = with spicePkgs.apps; [
          lyricsPlus
          marketplace
        ];
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          autoSkipVideo
          betterGenres
          bookmark
          fullAlbumDate
          fullAppDisplay
          groupSession
          hidePodcasts
          history
          keyboardShortcut
          loopyLoop
          phraseToPlaylist
          popupLyrics
          sectionMarker
          shuffle
          songStats
          trashbin
          volumePercentage
        ];
      };
    };
  };
}
