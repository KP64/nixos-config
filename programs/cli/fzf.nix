{ username, ... }:
{
  home-manager.users.${username}.programs.fzf.enable = true;
}
