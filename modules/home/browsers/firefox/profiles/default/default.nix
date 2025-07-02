{
  config,
  lib,
  pkgs,
  inputs,
  rootPath,
  ...
}:
let
  inherit (config.home) username;
in
lib.mkIf config.browsers.firefox.enable {
  catppuccin.firefox.profiles.${username}.force = true;

  programs.firefox.profiles.${username} = {
    extraConfig = builtins.readFile "${inputs.better-fox}/user.js";

    search = import ./search.nix { inherit lib pkgs rootPath; };

    settings =
      lib.custom.collectLastEntries
      <| lib.custom.appendLastWithFullPath
      <| {
        dom.security.https_only_mode = true;
        general = {
          autoScroll = true;
          smoothScroll = {
            currentVelocityWeighting = "1";
            stopDecelerationWeighting = "1";
            msdPhysics = {
              continuousMotionMaxDeltaMS = 12;
              enabled = true;
              motionBeginSpringConstant = 600;
              regularSpringConstant = 650;
              slowdownMinDeltaMS = 25;
              slowdownMinDeltaRatio = "2";
              slowdownSpringConstant = 250;
            };
          };
        };
        mousewheel.default.delta_multiplier_y = 300;
        sidebar.verticalTabs = true;
      };

    extensions = {
      force = true;
      packages = with pkgs.nur.repos.rycee.firefox-addons; [
        bitwarden
        catppuccin-web-file-icons
        darkreader
        dearrow
        enhancer-for-youtube
        facebook-container
        firefox-color
        i-dont-care-about-cookies
        indie-wiki-buddy
        languagetool
        libredirect
        private-relay
        refined-github
        return-youtube-dislikes
        simple-translate
        sponsorblock
        stylus
        tabliss
        ublock-origin
        videospeed
        youtube-recommended-videos
      ];
      # Libredirect Settings
      # it's actually a ".js" file, but importing it as JSON is easier :P
      settings."7esoorv3@alefvanoon.anonaddy.me".settings = lib.importJSON ./libredirect-settings.json;
    };
  };
}
