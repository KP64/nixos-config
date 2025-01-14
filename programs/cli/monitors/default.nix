{ config, lib, ... }:
let
  cfg = config.cli.monitors;
in
{
  imports = [
    ./bandwhich.nix
    ./btop.nix
  ];

  options.cli.monitors.enable = lib.mkEnableOption "Cli Monitors";

  config.cli.monitors = lib.mkIf cfg.enable {
    bandwhich.enable = lib.mkDefault true;
    btop.enable = lib.mkDefault true;
  };
}
