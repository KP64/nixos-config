{ config, lib, ... }:
let
  cfg = config.system.services.ssh;
in
{
  options.system.services.ssh.enable = lib.mkEnableOption "SSH";

  config = lib.mkMerge [
    { programs.ssh.startAgent = true; }

    (lib.mkIf cfg.enable {
      services.openssh = {
        enable = true;
        startWhenNeeded = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
        };
      };
    })
  ];
}
