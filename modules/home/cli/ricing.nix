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

  config = lib.mkIf cfg.enable {
    programs = {
      cava.enable = true;
      clock-rs.enable = true;
    };

    home.packages = with pkgs; [
      cbonsai
      cfonts
      cmatrix
      dwt1-shell-color-scripts
      figlet
      genact
      nms
      pipes-rs
      rust-stakeholder
      tenki
      toilet
      tty-clock
      rain
    ];
  };
}
