{ username, ... }:
{
  home-manager.users.${username}.programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  environment.persistence."/persist".users.${username}.directories = [
    ".local/share/zoxide"
  ];
}
