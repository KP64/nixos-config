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
      profiles.${username} = {
        settings = collectLastEntries (replaceLastWithFullPath {
          browser = {
            aboutConfig.showWarning = false;
            tabs.crashReporting.sendReport = false;
            contentblocking.category = "strict";
            discovery.enabled = false;
            translations.neverTranslateLanguages = "ar,de"; # Comma Seperated
            uitour.enabled = false;
            newtabpage.activity-stream = {
              showSponsored = false;
              showSponsoredTopSites = false;
            };
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

          media.ffmpeg.vaapi.enabled = true;

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
            archive.enabled = false;
            server = "";
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
