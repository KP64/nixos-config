{
  config,
  lib,
  rootPath,
  ...
}:
let
  cfg = config.apps.thunderbird;
in
{
  options.apps.thunderbird.enable = lib.mkEnableOption "Thunderbird";

  config.programs.thunderbird = {
    inherit (cfg) enable;
    profiles.${config.home.username} = {
      isDefault = true;

      search =
        let
          mkParam = name: value: { inherit name value; };
        in
        rec {
          force = true;
          default = "SearXNG";
          privateDefault = default;
          engines =
            lib.custom.hideEngines [
              "bing"
              "google"
              "wikipedia"
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
                icon = "${rootPath}/assets/firefox/searxng.svg";
                definedAliases = [ "@sx" ];
              };
            };
        };

      settings = lib.custom.collectLastEntries (
        lib.custom.appendLastWithFullPath {
          middlemouse.paste = false;
          general.autoScroll = true;

          extensions = {
            autoDisableScopes = 0;
            webcompat-reporter.enabled = false;
          };

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
        }
      );
    };
  };
}
