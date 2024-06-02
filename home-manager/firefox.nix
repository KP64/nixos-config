{ inputs, pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    profiles.kg = {
      settings = {
        "extensions.autoDisableScopes" = 0;
        "dom.security.https_only_mode" = true;
        "policies.DisableFirefoxStudies" = true;
        "policies.DisableTelemetry" = true;
      };

      extensions = with inputs.firefox-addons.packages."${pkgs.system}"; [
        ublock-origin
        darkreader
        simple-translate
        # enhancer-for-youtube # FIXME: Needs unfree even though enabled
        facebook-container
        firefox-color
        multi-account-containers
        return-youtube-dislikes
        privacy-badger
        greasemonkey
        i-dont-care-about-cookies
        # languagetool # See above
        private-relay
        videospeed
      ];
    };
  };
}
