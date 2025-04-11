{
  config,
  lib,
  customLib,
  pkgs,
  inputs,
  ...
}:

let
  nixos-icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";

  hideEngines =
    list:
    lib.genAttrs list (_: {
      metaData.hidden = true;
    });

  cfg = config.browsers.firefox;

  homeUsername = config.home.username;
in
{
  options.browsers.firefox.enable = lib.mkEnableOption "Firefox";

  config = lib.mkIf cfg.enable {
    # TODO: Use privacy respecting browser
    xdg.desktopEntries.i2p-browser = {
      name = "i2p Browser";
      genericName = "Web Browser";
      icon = ./i2p.svg;
      exec = "${lib.getExe pkgs.firefox} -p i2p";
    };

    home.file.".mozilla/firefox/${homeUsername}/chrome" = {
      source = "${inputs.potato-fox}/chrome/";
      recursive = true;
    };

    programs.firefox = {
      enable = true;
      profiles = {
        i2p = {
          id = 1;
          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              noscript
              ublock-origin
            ];
          };
          settings = customLib.collectLastEntries (
            customLib.appendLastWithFullPath {
              keyword.enabled = false;
              browser = {
                contentblocking.category = "strict";
                policies.applied = true;
              };
              network = {
                trr.mode = 5;
                proxy = {
                  http = "127.0.0.1";
                  http_port = 4444;
                  share_proxy_settings = true;
                  socks = "127.0.0.1";
                  socks_port = 4447;
                  type = 1;
                };
              };
            }
          );
        };

        ${homeUsername} = {
          extraConfig = builtins.readFile "${inputs.potato-fox}/user.js";
          search = {
            force = true;
            default = "SearXNG";
            privateDefault = "SearXNG";
            engines =
              let
                nix-snowflake-icon = "${nixos-icons}/nix-snowflake.svg";

                mkParam = name: value: { inherit name value; };
                nix-search-params = [
                  (mkParam "channel" "unstable")
                  (mkParam "query" "{searchTerms}")
                ];
              in
              hideEngines [
                "bing"
                "google"
                "ddg"
                "wikipedia"
                # TODO: Find a way to disable
                # "LibRedirect"
              ]
              // {
                SearXNG = {
                  urls = [
                    {
                      template = "https://searxng.nix-pi.ipv64.de/search";
                      params = [
                        (mkParam "q" "{searchTerms}")
                        (mkParam "language" "all")
                      ];
                    }
                  ];
                  icon = ./searxng.svg;
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
                "NixOS Wiki" = {
                  urls = [ { template = "https://wiki.nixos.org/wiki/{searchTerms}"; } ];
                  updateInterval = 24 * 60 * 60 * 1000; # every day
                  icon = nix-snowflake-icon;
                  definedAliases = [ "@nw" ];
                };
              };
          };
          settings = customLib.collectLastEntries (
            customLib.appendLastWithFullPath {
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
                security.esni.enabled = true;
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
            }
          );

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              bitwarden
              catppuccin-gh-file-explorer
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
              sidebery
              simple-translate
              sponsorblock
              stylus
              tabliss
              ublock-origin
              userchrome-toggle-extended
              videospeed
            ];
          };
        };
      };
    };
  };
}
