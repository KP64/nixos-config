{ lib, config, ... }:
{
  options.system.security.sudo-rs.enable = lib.mkEnableOption "Enable Mem Safe Sudo";

  config = lib.mkIf config.system.security.sudo-rs.enable {
    security.sudo-rs = {
      enable = true;
      execWheelOnly = true;
    };
  };
}
