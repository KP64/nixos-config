{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.cli.monitors.btop.enable = lib.mkEnableOption "Btop";

  config = lib.mkIf config.cli.monitors.btop.enable {
    home-manager.users.${username}.programs.btop = {
      enable = true;
      # Allows GPU detection for Nvidia cards
      package = pkgs.btop.override { cudaSupport = true; };
    };
  };
}
