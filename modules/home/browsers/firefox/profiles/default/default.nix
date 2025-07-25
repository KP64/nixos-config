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
        general.autoScroll = true;
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
      settings = {
        "uBlock0@raymondhill.net".settings = {
          selectedFilterLists = [
            "ublock-filters"
            "ublock-badware"
            "ublock-privacy"
            "ublock-quick-fixes"
            "ublock-unbreak"
            "easylist"
            "adguard-generic"
            "easyprivacy"
            "adguard-spyware"
            "adguard-spyware-url"
            "block-lan"
            "urlhaus-1"
            "curben-phishing"
            "plowe-0"
            "fanboy-cookiemonster"
            "ublock-cookies-easylist"
            "adguard-cookies"
            "ublock-cookies-adguard"
          ];
        };
      }
      // builtins.mapAttrs (_: v: { settings = lib.importJSON v; }) {
        "7esoorv3@alefvanoon.anonaddy.me" = ./libredirect-settings.json;
        "enhancerforyoutube@maximerf.addons.mozilla.org" = ./enhancer-for-youtube.json;
      };
    };
  };
}
