{
  den.aspects.kg.homeManager = {
    programs.atuin = {
      enable = true;
      forceOverwriteSettings = true;
      daemon.enable = true;
      settings = {
        invert = true;
        filter_mode_shell_up_key_binding = "directory";
        style = "auto";
        update_check = false;
        enter_accept = true;
        # TODO: Replace with homelab domain
        sync_address = "https://atuin.srvd.space";
      };
    };
  };
}
