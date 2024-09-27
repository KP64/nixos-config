{
  config,
  lib,
  ...
}:
{
  options.system.services.ssh.enable = lib.mkEnableOption "Enabled Openssh";

  config = lib.mkIf config.system.services.ssh.enable {
    programs.ssh.startAgent = true;

    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings.PasswordAuthentication = false;
    };
  };
}
