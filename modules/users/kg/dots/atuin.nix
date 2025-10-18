toplevel: {
  flake.modules.homeManager.users-kg = {
    programs.atuin = {
      enable = true;
      daemon.enable = true;
      settings = {
        invert = true;
        filter_mode_shell_up_key_binding = "directory";
        style = "auto";
        update_check = false;
        enter_accept = true;
        sync_address = "https://atuin.${toplevel.config.flake.nixosConfigurations.mahdi.config.networking.domain}";
      };
    };
  };
}
