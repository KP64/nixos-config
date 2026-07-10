{
  den.aspects.kg._.zellij.homeManager = { config, lib, ... }: {
    programs = {
      nushell.configFile.text = builtins.readFile ./start_zellij.nu;
      zellij = {
        enable = true;
        settings = {
          default_shell = lib.mkIf config.programs.nushell.enable "nu";
          show_startup_tips = false;
          ui.pane_frames.rounded_corners = true;
        };
      };
    };
  };
}
