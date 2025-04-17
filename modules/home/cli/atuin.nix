{ config, lib, ... }:
let
  cfg = config.cli.atuin;
in
{
  options.cli.atuin = {
    enable = lib.mkEnableOption "Atuin";

    sync_address = lib.mkOption {
      default = "https://atuin.nix-pi.ipv64.de";
      type = lib.types.nonEmptyStr;
      example = "https://api.atuin.sh";
      description = "The address of the server to sync with!";
    };
  };

  config.programs.atuin =
    let
      inherit (config.sops) secrets;
    in
    {
      inherit (cfg) enable;
      daemon.enable = true;
      settings =
        {
          inherit (cfg) sync_address;
          invert = true;
          filter_mode_shell_up_key_binding = "directory";
          style = "auto";
          update_check = false;
          enter_accept = true;
        }
        // lib.optionalAttrs (secrets ? "atuin/session" && secrets ? "atuin/key") {
          session_path = secrets."atuin/session".path;
          key_path = secrets."atuin/key".path;
        };
    };
}
