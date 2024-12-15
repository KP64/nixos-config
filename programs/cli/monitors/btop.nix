{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.cli.monitors.btop;
in
{
  options.cli.monitors.btop.enable = lib.mkEnableOption "Btop";

  config.home-manager.users.${username}.programs.btop = {
    inherit (cfg) enable;
    # Allows GPU detection for Nvidia cards
    package = pkgs.btop.override { cudaSupport = true; };
  };
}
