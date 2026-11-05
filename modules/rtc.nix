{
  den.aspects.rtc = { lib, ... }: {
    settings.type = lib.mkOption {
      default = "ds3231";
      example = "pcf8523";
      type = lib.types.enum [
        "ds3231"
        "ds1307"
        "pcf8523"
      ];
      description = "The type of RTC the Pi has";
    };

    nixos =
      {
        host,
        user,
        config,
        ...
      }:
      {
        users.users.${user.userName}.extraGroups = lib.optional (
          user.isAdmin && config.hardware.i2c.enable
        ) config.hardware.i2c.group;

        hardware = {
          i2c.enable = true;
          raspberry-pi.config.all = {
            dt-overlays."i2c-rtc,${host.settings.rtc.type}" = {
              enable = true;
              params = { };
            };
            base-dt-params.i2c_arm = {
              enable = true;
              value = "on";
            };
          };
        };
      };
  };
}
