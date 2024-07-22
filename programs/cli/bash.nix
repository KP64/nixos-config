{ username, ... }:
{
  environment.pathsToLink = [ "/share/bash-completion" ];
  home-manager.users.${username}.programs.bash.enable = true;
}
