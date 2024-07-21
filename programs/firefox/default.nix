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
  options.apps.firefox.enable = lib.mkEnableOption "Enables Firefox";

  config = lib.mkIf config.apps.firefox.enable {
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
              hideEngines [
                "Bing"
                "Google"
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
                      params = [
                        {
                          name = "type";
                          value = "packages";
                        }
                        {
                          name = "query";
                          value = "{searchTerms}";
                        }
                      ];
                    }
                  ];
                  icon = "${nixos-icons}/nix-snowflake.svg";
                  definedAliases = [ "@np" ];
                };
                "NixOS Wiki" = {
                  urls = [ { template = "https://nixos.wiki/wiki/{searchTerms}"; } ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  icon = "${nixos-icons}/nix-snowflake.svg";
                  definedAliases = [ "@nw" ];
                };
              };
          };
          settings = collectLastEntries (replaceLastWithFullPath {
            browser = {
              aboutConfig.showWarning = false;
              tabs.crashReporting.sendReport = false;
              discovery.enabled = false;
              translations.neverTranslateLanguages = "ar,de"; # Comma Seperated
              uitour.enabled = false;
              places.speculativeConnect.enabled = false;
              urlbar.speculativeConnect.enabled = false;
            };

            middlemouse.paste = false;
            general.autoScroll = true;

            extensions = {
              autoDisableScopes = 0;
              webcompat-reporter.enabled = false;
              pocket.enabled = false;
            };

            findbar.highlightAll = true;

            dom = {
              security.https_only_mode = true;
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

            network.predictor.enabled = false;

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
            darkreader
            decentraleyes
            enhancer-for-youtube
            facebook-container
            firefox-color
            greasemonkey
            i-dont-care-about-cookies
            languagetool
            libredirect
            new-tab-override
            privacy-badger
            private-relay
            return-youtube-dislikes
            sidebery
            simple-translate
            stylus
            ublock-origin
            userchrome-toggle-extended
            videospeed
            vimium
          ];
        };
      };
    };
  };
}
