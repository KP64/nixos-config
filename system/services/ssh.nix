{
  config,
  lib,
  ...
}:
{
  options.system.services.ssh.enable = lib.mkEnableOption "Enabled Openssh";

  config = lib.mkIf config.system.services.ssh.enable {
    programs.ssh.startAgent = true;
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
  };
}
