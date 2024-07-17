{
  pkgs,
  lib,
  config,
  username,
  collectLastEntries,
  replaceLastWithFullPath,
  ...
}:

{
  options.apps.firefox.enable = lib.mkEnableOption "Enables Firefox";

  config = lib.mkIf config.apps.firefox.enable {
    home-manager.users.${username}.programs.firefox = {
      enable = true;
      package = pkgs.firefox-devedition;
      profiles.${username} = {
        settings = collectLastEntries (replaceLastWithFullPath {
          breakpad.reportURL = "";

          browser = {
            sessionstore.privacy_level = 2;
            search.suggest.enabled = false;
            urlbar = {
              suggest = {
                searcher = false;
                engines = false;
                history = false;
                bookmark = false;
                openpage = false;
                topsites = false;
                weather = false;
              };
              merino.endpointURL = "";
              trending.featureGate = false;
              addons.featureGate = false;
              mdn.featureGate = false;
              pocket.featureGate = false;
              weather.featureGate = false;
              yelp.featureGate = false;
              clipboard.featureGate = false;
            };
            formfill.enable = false;
            translation.engine = "";
            aboutConfig.showWarning = false;
            tabs.crashReporting.sendReport = false;
            contentblocking = {
              database.enabled = false;
              cfr-milestone.enabled = false;
              category = "strict";

              reportBreakage.url = "";
              report = {
                cookie.url = "";
                cryptominer.url = "";
                fingerprinter.url = "";
                lockwise = {
                  enabled = false;
                  how_it_works.url = "";
                };
                manage_devices.url = "";
                monitor = {
                  enabled = false;
                  how_it_works.url = "";
                  sing_in_url = "";
                  url = "";
                  home_page_url = "";
                  preferences_url = "";
                };
                proxy.enabled = false;
                proxy_extensions.url = "";
                social.url = "";
                tracker.url = "";
                endpoint_url = "";
                vpn.enabled = false;
                hide_vpn_banner = true;
                show_mobile_app = false; # TODO: Check
              };
            };
            vpn_promo.enabled = false;
            promo.focus.enabled = false;
            discovery.enabled = false;
            translations.neverTranslateLanguages = "ar,de"; # Comma Seperated
            uitour.enabled = false;
            shopping.experience2023.active = false;
            newtabpage = {
              enabled = false;
              activity-stream = {
                showSponsored = false;
                showSponsoredTopSites = false;
                default.sites = "";
                telemetry = false;
                feeds.telemetry = false;
              };
            };
            region = {
              network.url = "";
              update.enabled = false;
            };
            topsites = {
              contile.enabled = false;
              useRemoteSetting = false;
            };
            startup = {
              page = 0;
              homepage = "about:blank";
            };
            shell.checkDefaultBrowser = false;
            places.speculativeConnect.enabled = false;
            urlbar.speculativeConnect.enabled = false;
          };

          places.history.enabled = false;

          captivedetect.cannonicalURL = "";

          services.settings.server = "";

          middlemouse.paste = false;
          general.autoScroll = true;

          extensions = {
            autoDisableScopes = 0;
            getAddons.showPane = false;
            htmlaboutaddons.recommendations.enabled = false;
            webcompat-reporter.enabled = false;
            pocket.enabled = false;
          };

          media = {
            webvtt = {
              debug.logging = false;
              testing.events = false;
            };
            ffmpeg.vaapi.enabled = true;
          };

          findbar.highlightAll = true;

          dom = {
            security.https_only_mode = true;
            battery.enabled = false;
            push = {
              enabled = false;
              connection.enabled = false;
              serverURL = "";
              userAgentID = "";
            };
          };

          security = {
            ssl.require_safe_negotiation = true;
            tls.enable_0rtt_data = false;
          };

          policies = {
            DisableFirefoxStudies = true;
            DisableTelemetry = true;
          };

          privacy = {
            sanitizeOnShutdown = true;
            clearOnShutdown = {
              cache = true;
              cookies = true;
              downloads = true;
              formdata = true;
              history = true;
            };
            clearOnShutdown_v2 = {
              cache = true;
              historyFormDataAndDownloads = true;
            };
            globalprivacycontrol.enabled = true;
            donottrackheader.enabled = true;
            fingerprintingProtection = true;
            trackingprotection = {
              enabled = true;
              socialtracking.enabled = true;
            };
            resistFingerprinting = true; # TODO:
            spoof_english = 2;
            userContext = {
              enabled = true;
              ui.enabled = true;
            };
          };

          app = {
            messaging-system.rsexperimentloader.enabled = false;
            normandy = {
              enabled = false;
              api_url = "";
            };
            shield.optoutstudies.enabled = false;
            feedback.baseURL = "";
            support.baseURL = "";
            releaseNotesURL = "";
            update = {
              url = {
                details = "";
                manual = "";
              };
              staging.enabled = false;
            };
          };

          gecko.handlerService.schemes = {
            "mailto.0" = {
              uriTemplate = "";
              name = "";
            };
            "mailto.1" = {
              uriTemplate = "";
              name = "";
            };
            "irc.0" = {
              uriTemplate = "";
              name = "";
            };
            "ircs.0" = {
              uriTemplate = "";
              name = "";
            };
          };

          beacon.enabled = false;
          device.sensors.enabled = false;
          geo = {
            enabled = false;
            provider = {
              network.url = "";
              use_gpsd = false;
              use_geoclue = false;
              geoclue.always_high_accuracy = false;
            };
          };

          network = {
            prefetch-next = false;
            dns.disablePrefetch = true;
            connectivity-service.enabled = false;
            captive-portal-service.enabled = false;
            http.speculative-parallel-limit = 0;
            predictor.enabled = false;
            proxy.socks_remote_dns = true;
            file_disable_unc_paths = true;
            supported-protocols = "";
          };

          toolkit = {
            coverage = {
              opt-out = true;
              endpoint.base = "";
            };
            telemetry = {
              enabled = false;
              archive.enabled = false;
              server = "data:,";
              unified = false;
              newProfilePing.enabled = false;
              shutdownPingSender.enabled = false;
              updatePing.enabled = false;
              bhrPing.enabled = false;
              firstShutdownPing.enabled = false;
              coverage.opt-out = true;
            };
          };

          datareporting = {
            policy.dataSubmissionEnabled = false;
            healthreport.uploadEnabled = false;
          };
        });

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          simple-translate
          enhancer-for-youtube
          new-tab-override
          facebook-container
          firefox-color
          multi-account-containers
          return-youtube-dislikes
          privacy-badger
          greasemonkey
          i-dont-care-about-cookies
          languagetool
          private-relay
          videospeed
          stylus
        ];
      };
    };
  };
}
