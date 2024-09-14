{
  pkgs,
  lib,
  config,
  inputs,
  username,
  collectLastEntries,
  replaceLastWithFullPath,
  ...
}:

let
  nixos-icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";

  hideEngines =
    list:
    lib.genAttrs list (_: {
      metaData.hidden = true;
    });
in
{
  options.apps.browsers.firefox.enable = lib.mkEnableOption "Enables Firefox";

  config = lib.mkIf config.apps.browsers.firefox.enable {
    home-manager.users.${username} = {
      home.file.".mozilla/firefox/${username}/chrome" = {
        source = "${inputs.potato-fox}/chrome/";
        recursive = true;
      };
      programs.firefox = {
        enable = true;
        profiles.${username} = {
          extraConfig = builtins.readFile "${inputs.potato-fox}/user.js";
          search = {
            force = true;
            default = "SearXNG";
            privateDefault = "SearXNG";
            engines =
              let
                nix-snowflake-icon = "${nixos-icons}/nix-snowflake.svg";
                nix-search-params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              in
              hideEngines [
                "Bing"
                "Google"
                "DuckDuckGo"
                "Wikipedia (en)"
              ]
              // {
                SearXNG = {
                  urls = [
                    {
                      template = "https://search.sapti.me/search";
                      params = [
                        {
                          name = "q";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = ./searxng.svg;
                  definedAliases = [ "@sx" ];
                };
                "Nix Pkgs" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/packages";
                      params = nix-search-params;
                    }
                  ];
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@np" ];
                };
                "Nix Optns" = {
                  urls = [
                    {
                      template = "https://search.nixos.org/options";
                      params = nix-search-params;
                    }
                  ];
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@no" ];
                };
                "NixOS Wiki" = {
                  urls = [ { template = "https://nixos.wiki/wiki/{searchTerms}"; } ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@nw" ];
                };
              };
          };
          settings = collectLastEntries (replaceLastWithFullPath {
            browser = {
              aboutConfig.showWarning = false;
              aboutwelcome.enabled = false;
              contentblocking.category = "strict";
              shell.checkDefaultBrowser = false;
              tabs.crashReporting.sendReport = false;
              discovery.enabled = false;
              download.manager.addToRecentDocs = false;
              bookmarks.openInTabClosesMenu = false;
              translations.neverTranslateLanguages = "ar,de"; # Comma Seperated
              uitour.enabled = false;
              profiles.enabled = true;
              privatebrowsing.forceMediaMemoryCache = true;
              search.separatePrivateDefault.ui.enabled = true;
              places.speculativeConnect.enabled = false;
              urlbar = {
                speculativeConnect.enabled = false;
                urlbar = {
                  suggest = {
                    engines = false;
                    calculator = true;
                  };
                  unitConversion.enabled = true;
                  trending.featureGate = false;
                };
              };
            };

            middlemouse.paste = false;
            general.autoScroll = true;

            extensions = {
              autoDisableScopes = 0;
              webcompat-reporter.enabled = false;
              pocket.enabled = false;
              htmlaboutaddons.recommendations.enabled = false;
            };

            findbar.highlightAll = true;

            security = {
              OCSP.enabled = 0;
              remote_settings.crlite_filters.enabled = true;
              pki.crlite_mode = 2;
            };

            dom = {
              security = {
                https_only_mode = true;
                https_first = true;
                sanitizer.enabled = true;
              };
              battery.enabled = false;
              push = {
                enabled = false;
                connection.enabled = false;
              };
            };

            policies = {
              DisableFirefoxStudies = true;
              DisableTelemetry = true;
            };

            privacy = {
              globalprivacycontrol.enabled = true;
              donottrackheader.enabled = true;
              fingerprintingProtection = true;
              trackingprotection = {
                enabled = true;
                socialtracking.enabled = true;
              };
              userContext = {
                enabled = true;
                ui.enabled = true;
              };
            };

            app = {
              normandy.enabled = false;
              shield.optoutstudies.enabled = false;
            };

            beacon.enabled = false;
            device.sensors.enabled = false;
            geo.enabled = false;

            network = {
              dns = {
                disablePrefetch = true;
                disablePrefetchFromHTTPS = true;
              };
              predictor.enabled = false;
            };

            toolkit.telemetry = {
              enabled = false;
              archive.enabled = false;
              unified = false;
            };

            datareporting = {
              policy.dataSubmissionEnabled = false;
              healthreport.uploadEnabled = false;
            };
          });

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            catppuccin-gh-file-explorer
            darkreader
            enhancer-for-youtube
            facebook-container
            firefox-color
            i-dont-care-about-cookies
            languagetool
            libredirect
            private-relay
            refined-github
            return-youtube-dislikes
            sidebery
            simple-translate
            stylus
            ublock-origin
            userchrome-toggle-extended
            videospeed
          ];
        };
      };
    };
  };
}
