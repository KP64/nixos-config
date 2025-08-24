{ config, ... }:
let
  inherit (config.sops) secrets;
in
{
  programs.atuin = {
    enable = true;
    daemon.enable = true;
    settings = {
      sync_address = "https://atuin.holab.ipv64.de";
      invert = true;
      filter_mode_shell_up_key_binding = "directory";
      style = "auto";
      update_check = false;
      enter_accept = true;
      session_path = secrets."atuin/session".path;
      key_path = secrets."atuin/key".path;
    };
  };
}
