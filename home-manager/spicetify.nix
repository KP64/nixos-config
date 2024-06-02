{
  pkgs,
  lib,
  inputs,
  ...
}:

let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];

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
}
