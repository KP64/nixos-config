{
  lib,
  config,
  username,
  ...
}:
{
  options.apps.thunderbird.enable = lib.mkEnableOption "Enables Thunderbird";

  config = lib.mkIf config.apps.thunderbird.enable {
    home-manager.users.${username}.programs.thunderbird = {
      enable = true;
      profiles.${username} = {
        isDefault = true;
        settings = {
          "middlemouse.paste" = false;
          "general.autoScroll" = true;

          "browser.translations.neverTranslateLanguages" = "de"; # Comma Seperated

          "extensions.webcompat-reporter.enabled" = false;

          "media.ffmpeg.vaapi.enabled" = true;

          "findbar.highlightAll" = true;

          "dom.security.https_only_mode" = true;
          "dom.push.connection.enabled" = false;
          "dom.battery.enabled" = false;

          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.socialtracking.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.emailtracking.enabled" = true;

          "beacon.enabled" = false;
          "device.sensors.enabled" = false;
          "geo.enabled" = false;

          "network.predictor.enabled" = false;

          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.owner" = "";

          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.healthreport.uploadEnabled" = false;
        };
      };
    };
  };
}
