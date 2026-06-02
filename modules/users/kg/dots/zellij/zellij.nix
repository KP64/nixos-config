{
  den.aspects.kg._.zellij.homeManager = { config, lib, ... }: {
    # TODO: Reenable Integrations once Zellij has better (kitty) SSH support.
    programs = {
      # nushell.configFile.text = builtins.readFile ./start_zellij.nu;
      zellij = {
        enable = true;
        # Integrations are not enabled by default.
        # enableBashIntegration = true;
        # enableFishIntegration = true;
        # enableZshIntegration = true;
        # exitShellOnExit = true;
        settings = {
          default_shell = lib.mkIf config.programs.nushell.enable "nu";
          show_startup_tips = false;
          ui.pane_frames.rounded_corners = true;
        };
      };
    };
  };
}
