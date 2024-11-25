{
  config,
  lib,
  ...
}:
{
  options.system.services.ssh.enable = lib.mkEnableOption "Openssh";

  config = lib.mkMerge [
    { programs.ssh.startAgent = true; }

    (lib.mkIf config.system.services.ssh.enable {
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
      environment.persistence."/persist".directories = lib.optional config.system.impermanence.enable "/var/lib/fail2ban";
    })
  ];
}
