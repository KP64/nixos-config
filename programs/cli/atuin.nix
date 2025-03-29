{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.cli.atuin;
in
{
  options.cli.atuin.sync_address = lib.mkOption {
    default = "https://atuin.nix-pi.ipv64.de";
    type = with lib.types; nullOr nonEmptyStr;
    example = "https://api.atuin.sh";
    description = "The address of the server to sync with!";
  };

  # TODO: Provide atuin key_path via sops-nix
  config = lib.mkMerge [
    {
      home-manager.users.${username}.programs.atuin = {
        enable = true;
        daemon.enable = true;
        settings = {
          inherit (cfg) sync_address;
          invert = true;
          filter_mode_shell_up_key_binding = "directory";
          style = "auto";
          update_check = false;
          enter_accept = true;
        };
      };
    }

    (lib.mkIf config.isImpermanenceEnabled {
      environment.persistence."/persist".users.${username}.directories = [ ".local/share/atuin" ];
    })
  ];
}
