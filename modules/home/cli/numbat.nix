{ config, lib, ... }:
let
  cfg = config.cli.numbat;
in
{
  options.cli.numbat.enable = lib.mkEnableOption "Numbat";

  config.programs.numbat = {
    inherit (cfg) enable;
    settings = {
      intro-banner = "off";
      exchange-rates.fetching-policy = "on-first-use";
    };
  };
}
