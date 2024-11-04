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
    environment.persistence."/persist".users.${username}.directories = [
      ".config/spotify"
      ".cache/spotify"
    ];
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
  };
}
