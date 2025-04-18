{ lib }:
lib.custom.collectLastEntries
<| lib.custom.appendLastWithFullPath
<| {
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
