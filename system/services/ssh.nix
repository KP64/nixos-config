{
  config,
  lib,
  ...
}:
let
  cfg = config.system.services.ssh;
in
{
  options.system.services.ssh.enable = lib.mkEnableOption "Openssh";

  config = lib.mkMerge [
    { programs.ssh.startAgent = true; }

    {
      services = {
        openssh = {
          inherit (cfg) enable;
          startWhenNeeded = true;
          settings = {
            PasswordAuthentication = false;
            KbdInteractiveAuthentication = false;
          };
        };
        fail2ban = {
          inherit (cfg) enable;
          bantime-increment = {
            enable = true;
            maxtime = "48h";
            overalljails = true;
            rndtime = "8m";
          };
        };
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".directories = lib.optional cfg.enable "/var/lib/fail2ban";
    })
  ];
}
