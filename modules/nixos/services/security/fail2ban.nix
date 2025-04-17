{ config, lib, ... }:
let
  cfg = config.services.security.fail2ban;
in
{
  # TODO: Add jails for other Services
  options.services.security.fail2ban = {
    enable = lib.mkEnableOption "Fail2ban";

    ignoreIP = lib.mkOption {
      default = [ ];
      type = with lib.types; listOf nonEmptyStr;
      description = "List of IP addresses, CIDR masks or DNS hosts to ignore.";
      example = [
        "192.168.0.0/16"
        "2001:DB8::42"
      ];
    };
  };

  config.services.fail2ban = {
    inherit (cfg) enable ignoreIP;
    bantime-increment = {
      enable = true;
      overalljails = true;
    };
  };
}
