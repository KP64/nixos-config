{
  config,
  lib,
  username,
  ...
}:
lib.mkMerge [
  {
    home-manager.users.${username}.programs.atuin = {
      enable = true;
      settings = {
        invert = true;
        filter_mode_shell_up_key_binding = "directory";
      };
    };
  }

  (lib.mkIf config.isImpermanenceEnabled {
    environment.persistence."/persist".users.${username}.directories = [ ".local/share/atuin" ];
  })
]
