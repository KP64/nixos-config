{
  lib,
  config,
  username,
  ...
}:
{
  options.cli.shells.bash.enable = lib.mkEnableOption "Enable Bash";

  config = lib.mkIf config.desktop.rofi.enable {
    environment.pathsToLink = [ "/share/bash-completion" ];
    home-manager.users.${username}.programs.bash.enable = true;
  };
}
