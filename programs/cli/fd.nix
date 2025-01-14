{ username, ... }:
{
  home-manager.users.${username}.programs.fd = {
    enable = true;
    hidden = true;
  };
}
