{ config, lib, ... }:
let
  cfg = config.services.media.redlib;
in
{
  options.services.media.redlib.enable = lib.mkEnableOption "Redlib";

  config.services.redlib = {
    inherit (cfg) enable;
    openFirewall = true;
    port = 8090;
    settings = {
      REDLIB_DEFAULT_BLUR_SPOILER = "on";
      REDLIB_DEFAULT_SHOW_NSFW = "on";
      REDLIB_DEFAULT_BLUR_NSFW = "on";
    };
  };
}
