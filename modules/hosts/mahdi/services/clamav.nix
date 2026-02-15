{
  flake.aspects.hosts-mahdi.nixos = {
    services.clamav = {
      clamonacc.enable = true;
      daemon = {
        enable = true;
        settings = {
          DetectPUA = true;
          ExtendedDetectionInfo = true;
          FollowDirectorySymlinks = true;
          FollowFileSymlinks = true;
          LogSyslog = true;
          LogTime = true;
        };
      };
      updater.enable = true;
      scanner.enable = true;
      fangfrisch.enable = true;
    };
  };
}
