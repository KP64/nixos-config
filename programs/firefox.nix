{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.apps.firefox.enable = lib.mkEnableOption "Enables Firefox";

  config = lib.mkIf config.apps.firefox.enable {
    home-manager.users.${username}.programs.firefox = {
      enable = true;
      profiles.${username} = {
        settings = {
          "general.autoScroll" = true;

          "browser.tabs.crashReporting.sendReport" = false;
          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;
          "browser.translations.neverTranslateLanguages" = "de"; # Comma Seperated
          "browser.uitour.enabled" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;

          "extensions.autoDisableScopes" = 0;
          "extensions.webcompat-reporter.enabled" = false;
          "extensions.pocket.enabled" = false;

          "media.ffmpeg.vaapi.enabled" = true;

          "findbar.highlightAll" = true;

          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "dom.push.enabled" = false;
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false;

          "policies.DisableFirefoxStudies" = true;
          "policies.DisableTelemetry" = true;

          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;

          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;

          "beacon.enabled" = false;
          "device.sensors.enabled" = false;
          "geo.enabled" = false;

          "network.predictor.enabled" = false;

          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.unified" = false;

          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
        };

        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          darkreader
          simple-translate
          enhancer-for-youtube
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
