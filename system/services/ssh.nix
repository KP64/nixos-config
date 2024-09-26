{
  config,
  lib,
  ...
}:
{
  options.system.services.ssh.enable = lib.mkEnableOption "Enabled Openssh";

  config = lib.mkIf config.system.services.ssh.enable {
    services.openssh = {
      enable = true;
      startWhenNeeded = true;
      settings.PasswordAuthentication = false;
    };
  };
}
