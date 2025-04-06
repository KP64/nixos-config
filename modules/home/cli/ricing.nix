{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.ricing;
in
{
  options.cli.ricing.enable = lib.mkEnableOption "All ricing";

  config.home.packages = lib.optionals cfg.enable (
    with pkgs;
    [
      cbonsai
      cfonts
      cmatrix
      genact
      nms
      pipes-rs
    ]
  );
}
