{ config, lib, ... }:
let
  cfg = config.system.services.ssh;
in
{
  options.system.services.ssh.enable = lib.mkEnableOption "Openssh";

  config = lib.mkMerge [
    { programs.ssh.startAgent = true; }

    (lib.mkIf cfg.enable {
      services = {
        openssh = {
          enable = true;
          startWhenNeeded = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
        fail2ban = {
          enable = true;
          bantime-increment = {
            enable = true;
            maxtime = "48h";
            overalljails = true;
            rndtime = "8m";
          };
        };
      };
    })

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/fail2ban";
    })
  ];
}
