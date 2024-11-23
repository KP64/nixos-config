{ lib, config, ... }:

{
  options.system.security.polkit.enable = lib.mkEnableOption "polkit";

  config = lib.mkIf config.system.security.polkit.enable { security.polkit.enable = true; };
}
