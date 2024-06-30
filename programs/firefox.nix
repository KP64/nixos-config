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
      profiles.kg = {
        settings = {
          "general.autoScroll" = true;

          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;
          "browser.translations.neverTranslateLanguages" = "de"; # Comma Seperated

          "extensions.autoDisableScopes" = 0;

          "findbar.highlightAll" = true;

          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;

          "policies.DisableFirefoxStudies" = true;
          "policies.DisableTelemetry" = true;

          "privacy.donottrackheader.enabled" = true;
          "privacy.fingerprintingProtection" = true;
          "privacy.globalprivacycontrol.enabled" = true;
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
