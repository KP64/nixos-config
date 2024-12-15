{ lib, config, ... }:
let
  cfg = config.system.security.sudo-rs;
in
{
  options.system.security.sudo-rs.enable = lib.mkEnableOption "Sudo-rs";

  config.security.sudo-rs = {
    inherit (cfg) enable;
    execWheelOnly = true;
  };
}
