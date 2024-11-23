{ lib, config, ... }:
{
  options.system.security.sudo-rs.enable = lib.mkEnableOption "Sudo-rs";

  config = lib.mkIf config.system.security.sudo-rs.enable {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
