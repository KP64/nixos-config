{
  config,
  lib,
  username,
  ...
}:
{
  home-manager.users.${username}.programs.atuin = {
    enable = true;
    settings = {
      invert = true;
      filter_mode_shell_up_key_binding = "directory";
    };
  };
}
// (lib.mkIf config.system.impermanence.enable {
  environment.persistence."/persist".users.${username}.directories = [ ".local/share/atuin" ];
})
