{
  config,
  lib,
  username,
  ...
}:
{
  home-manager.users.${username}.programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  environment.persistence."/persist".users.${username}.directories = lib.optional config.system.impermanence.enable ".local/share/zoxide";
}
