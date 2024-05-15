{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  spicetify = inputs.spicetify-nix;
  spicePkgs = spicetify.packages.${pkgs.system}.default;
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];

  imports = [ spicetify.homeManagerModule ];

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
}
