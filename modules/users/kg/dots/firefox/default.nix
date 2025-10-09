toplevel@{ inputs, customLib, ... }:
{
  flake.modules.homeManager.users-kg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      # TODO: Change new tabs and startup to glance
      programs.firefox = {
        enable = true;
        profiles.${config.home.username} = {
          extraConfig = builtins.readFile (inputs.better-fox + /user.js);

          settings = customLib.firefox.toFirefoxSettingStyle {
            network.trr.mode = 5; # Off by choice -> Uses system DNS resolver
            media.peerconnection.enabled = false; # Disable WebRTC -> prevents DNS leakage
            extensions.autoDisableScopes = 0;
            dom.security.https_only_mode = true;
            general.autoScroll = true;
            sidebar.verticalTabs = true;
          };

          search = {
            force = true;
            default = "SearXNG";
            privateDefault = "SearXNG";
            engines =
              let
                inherit (toplevel.config.flake.nixosConfigurations) mahdi;
                nix-snowflake-icon = builtins.path { path = inputs.self + /assets/nix-snowflake.svg; };

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
                      template = "${mahdi.config.services.searx.settings.server.base_url}/search";
                      params = [
                        (mkParam "q" "{searchTerms}")
                        (mkParam "language" "all")
                      ];
                    }
                  ];
                  icon = builtins.path { path = inputs.self + /assets/searxng.svg; };
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
