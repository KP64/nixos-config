{
  den.aspects.rpi._.rtc.nixos = { config, lib, ... }: {
    options.rtcType = lib.mkOption {
      default = "ds3231";
      example = "pcf8523";
      type = lib.types.enum [
        "ds3231"
        "ds1307"
        "pcf8523"
      ];
      description = "The type of RTC the Pi has";
    };

    config.hardware = {
      i2c.enable = true;
      raspberry-pi.config.all = {
        dt-overlays."i2c-rtc,${config.rtcType}" = {
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
}
