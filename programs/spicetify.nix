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
      imports = with inputs; [ spicetify-nix.homeManagerModule ];
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          autoSkipVideo
          fullAppDisplay
          hidePodcasts
          history
          keyboardShortcut
          lastfm
          playlistIcons
          popupLyrics
          shuffle
        ];
      };
    };
  };
}
