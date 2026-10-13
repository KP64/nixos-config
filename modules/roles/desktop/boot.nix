{
  # NOTE: Settings are taken from https://wiki.nixos.org/wiki/Plymouth
  den.default.nixos =
    { host, lib, ... }:
    lib.optionalAttrs host.isDesktop {
      boot = {
        plymouth.enable = true;

        # Enable "Silent boot"
        consoleLogLevel = 3;
        initrd.verbose = false;
        kernelParams = [
          "quiet"
          "rd.udev.log_level=3"
          "rd.systemd.show_status=auto"
        ];

        # Hide the OS choice for bootloaders.
        # It's still possible to open the bootloader list by pressing any key
        # It will just not appear on screen unless a key is pressed
        loader.timeout = 0;
      };
    };
}
