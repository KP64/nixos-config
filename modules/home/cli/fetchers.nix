{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.fetchers;
in
{
  options.cli.fetchers.enable = lib.mkEnableOption "Fetchers";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      onefetch
      cpufetch
    ];

    programs.fastfetch.enable = true;
  };
}
