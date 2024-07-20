{
  pkgs,
  lib,
  config,
  username,
  collectLastEntries,
  replaceLastWithFullPath,
  ...
}:

let
  nixos-icons = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps";
in
{
  options.apps.firefox.enable = lib.mkEnableOption "Enables Firefox";

  config = lib.mkIf config.apps.firefox.enable {
    home-manager.users.${username}.programs.firefox = {
      enable = true;
      profiles.${username} = {
        search = {
          force = true;
          default = "SearXNG";
          privateDefault = "SearXNG";
          engines = {
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
            "SearXNG" = {
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
          ublock-origin
          darkreader
          simple-translate
          enhancer-for-youtube
          decentraleyes
          facebook-container
          firefox-color
          return-youtube-dislikes
          privacy-badger
          greasemonkey
          i-dont-care-about-cookies
          languagetool
          private-relay
          videospeed
          stylus
          libredirect
          new-tab-override
        ];
      };
    };
  };
}
