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
    programs.cava.enable = true;
    home.packages = with pkgs; [
      cbonsai
      cfonts
      cmatrix
      figlet
      genact
      nms
      pipes-rs
      rust-stakeholder
      toilet
    ];
  };
}
