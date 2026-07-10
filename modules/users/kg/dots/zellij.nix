{
  den.aspects.kg._.zellij.homeManager = { config, lib, ... }: {
    programs.zellij = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;

      attachExistingSession = true;
      exitShellOnExit = true;
      settings = {
        default_shell = lib.mkIf config.programs.nushell.enable "nu";
        show_startup_tips = false;
        ui.pane_frames.rounded_corners = true;
      };
    };
  };
}
