{
  config,
  lib,
  username,
  ...
}:
lib.mkMerge [
  {
    home-manager.users.${username}.programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  }

  (lib.mkIf config.isImpermanenceEnabled {
    environment.persistence."/persist".users.${username}.directories = [ ".local/share/zoxide" ];
  })
]
