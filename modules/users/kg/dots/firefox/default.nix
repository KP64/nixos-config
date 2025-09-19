{ inputs, customLib, ... }:
{
  flake.modules.homeManager.users-kg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        profiles.${config.home.username} = {
          extraConfig = builtins.readFile "${inputs.better-fox}/user.js";

          settings = customLib.firefox.toFirefoxSettingStyle {
            extensions.autoDisableScopes = 0;
            dom.security.https_only_mode = true;
            general.autoScroll = true;
            sidebar.verticalTabs = true;
          };

          search = {
            force = true;
            default = "duckduckgo";
            privateDefault = "duckduckgo";
            engines =
              let
                nix-snowflake-icon = "${inputs.self}/assets/nix-snowflake.svg";

                mkParam = name: value: { inherit name value; };
                nix-search-params = [
                  (mkParam "channel" "unstable")
                  (mkParam "query" "{searchTerms}")
                ];
              in
              customLib.firefox.hideEngines [
                "bing"
                "ecosia"
                "google"
                "wikipedia"
              ]
              // {
                SearXNG = {
                  urls = [
                    {
                      # TODO: Use correct URL
                      template = "https://searxng.holab.ipv64.de/search";
                      params = [
                        (mkParam "q" "{searchTerms}")
                        (mkParam "language" "all")
                      ];
                    }
                  ];
                  icon = "${inputs.self}/assets/searxng.svg";
                  definedAliases = [ "@sx" ];
                };
                "Home Manager" = {
                  urls = [
                    {
                      template = "https://home-manager-options.extranix.com";
                      params = [
                        (mkParam "query" "{searchTerms}")
                        (mkParam "release" "master")
                      ];
                    }
                  ];
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@hm" ];
                };
                "Nix Packages" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = nix-search-params;
                    }
                  ];
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@np" ];
                };
                "Nix Options" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = nix-search-params;
                    }
                  ];
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@no" ];
                };
                # TODO: Available in SearXNG now -> Remove
                "NixOS Wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/wiki/{searchTerms}"; } ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@nw" ];
                };
              };
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
            ];
            # Libredirect Settings
            # it's actually a ".js" file, but importing it as JSON is easier :P
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
    };
}
