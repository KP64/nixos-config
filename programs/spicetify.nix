{
  pkgs,
  lib,
  config,
  inputs,
  username,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  options.apps.spicetify.enable = lib.mkEnableOption "Enables Spicetify";

  config = lib.mkIf config.apps.spicetify.enable {
    home-manager.users.${username} = {
      imports = [ inputs.spicetify-nix.homeManagerModule ];
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledCustomApps = with spicePkgs.apps; [ marketplace ];
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          autoSkipVideo
          fullAlbumDate
          fullAppDisplay
          groupSession
          hidePodcasts
          history
          keyboardShortcut
          lastfm
          playlistIcons
          popupLyrics
          shuffle
          songStats
          trashbin
          volumePercentage
        ];
      };
    };
  };
}
