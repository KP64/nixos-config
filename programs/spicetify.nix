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
  imports = with inputs; [ spicetify-nix.homeManagerModule ];
  options.apps.spicetify.enable = lib.mkEnableOption "Enables Spicetify";

  config = lib.mkIf config.apps.spicetify.enable {
    # TODO: This doesn't work for whatever reason.
    # ? Leaving it out and import from HM works though.
    home-manager.users.${username} = {
      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "spotify" ];
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
