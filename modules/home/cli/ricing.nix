{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.cli.ricing;
in
{
  options.cli.ricing.enable = lib.mkEnableOption "All ricing";

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.dotz.packages.${pkgs.system}.default
    ]
    ++ (with pkgs; [
      cbonsai
      cfonts
      cmatrix
      dipc
      genact
      nms
      pipes-rs
      rust-stakeholder
      tenki
      toilet
    ]);

    programs = {
      cava.enable = true;
      clock-rs.enable = true;
    };
  };
}
