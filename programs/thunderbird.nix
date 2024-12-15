{
  lib,
  config,
  username,
  collectLastEntries,
  appendLastWithFullPath,
  ...
}:
let
  cfg = config.apps.thunderbird;
in
{
  options.apps.thunderbird.enable = lib.mkEnableOption "Thunderbird";

  config.home-manager.users.${username}.programs.thunderbird = {
    inherit (cfg) enable;
    profiles.${username} = {
      isDefault = true;
      settings = collectLastEntries (appendLastWithFullPath {
        middlemouse.paste = false;
        general.autoScroll = true;

        browser.translations.neverTranslateLanguages = "ar,de"; # Comma Seperated

        extensions.webcompat-reporter.enabled = false;

        media.ffmpeg.vaapi.enabled = true;

        findbar.highlightAll = true;

        dom = {
          security.https_only_mode = true;
          push.connection.enabled = false;
          battery.enabled = false;
        };

        privacy = {
          globalprivacycontrol.enabled = true;
          clearOnShutdwon.cache = true;
          fingerprintingProtection = true;
          donottrackheader.enabled = true;
          trackingprotection = {
            fingerprinting.enabled = true;
            socialtracking.enabled = true;
            cryptomining.enabled = true;
            emailtracking.enabled = true;
          };

          beacon.enabled = false;
          device.sensors.enabled = false;
          geo.enabled = false;

          network.predictor.enabled = false;

          toolkit.telemetry = {
            unified = false;
            server = "";
            owner = "";
            newProfilePing.enabled = false;
            updatePing.enabled = false;
            shutdownPingSender.enabled = false;
            archive.enabled = false;
            bhrPing.enabled = false;
          };

          datareporting = {
            policy.dataSubmissionEnabled = false;
            healthreport.uploadEnabled = false;
          };
        };
      });
    };
  };
}
