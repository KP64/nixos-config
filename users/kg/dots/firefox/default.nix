{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.home) username;
in
{
  catppuccin.firefox.profiles.${username}.force = true;

  programs.firefox = {
    enable = true;

    profiles.${username} = {
      extraConfig = builtins.readFile "${inputs.better-fox}/user.js";

      search = import ./search.nix { inherit lib pkgs inputs; };

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
          facebook-container
          firefox-color
          indie-wiki-buddy
          libredirect
          private-grammar-checker-harper
          private-relay
          refined-github
          return-youtube-dislikes
          simple-translate
          sponsorblock
          stylus
          tabliss
          ublock-origin
          videospeed
          vimium
          youtube-recommended-videos
        ];

        # These are actually JS files, but
        # are imported as JSON.
        settings = {
          "7esoorv3@alefvanoon.anonaddy.me".settings = lib.importJSON ./libredirect-settings.json;
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
        };
      };
    };
  };
}
