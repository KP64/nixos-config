{
  den.aspects.kg._.zellij.homeManager = { config, lib, ... }: {
    programs.zellij = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableZshIntegration = config.programs.zsh.enable;

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
