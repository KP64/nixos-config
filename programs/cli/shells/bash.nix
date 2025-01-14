{
  lib,
  config,
  username,
  ...
}:
{
  options.cli.shells.bash.enable = lib.mkEnableOption "Bash";

  config = lib.mkIf config.cli.shells.bash.enable {
    environment.pathsToLink = [ "/share/bash-completion" ];
    home-manager.users.${username}.programs.bash.enable = true;
  };
}
