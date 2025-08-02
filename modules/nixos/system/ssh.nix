{ config, lib, ... }:
let
  cfg = config.system.ssh;
in
{
  options.system.ssh.enable = lib.mkEnableOption "SSH";

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
