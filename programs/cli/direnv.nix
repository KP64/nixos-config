{ username, ... }:
{
  home-manager.users.${username} = {
    home.sessionVariables.DIRENV_LOG_FORMAT = "";
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
