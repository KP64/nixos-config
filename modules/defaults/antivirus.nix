{
  # TODO: Decide on better enable logic
  den.default.nixos =
    { config, lib, ... }:
    lib.mkIf config.services.coder.enable {
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
