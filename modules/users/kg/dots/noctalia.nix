toplevel@{ self, inputs, ... }:
{
  flake.modules.homeManager.users-kg-noctalia-shell =
    { config, lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".cache/noctalia/wallpapers.json" = lib.mkIf config.programs.noctalia-shell.enable {
        text = builtins.toJSON {
          defaultWallpaper = toplevel.config.lib.flake.util.getAsset {
            file = "cabin.png";
            type = "wallpapers/catppuccin";
          };
        };
      };

      # TODO: Replace with custom Quickshell config
      programs.noctalia-shell = {
        enable = true;
        settings = {
          # NOTE: Catppuccin Lavender Scheme isn't installed by default.
          #       Imperative downloading from Noctalia UI is needed on first boot.
          colorSchemes = lib.mkIf config.catppuccin.enable {
            predefinedScheme = "Catppuccin${
              lib.optionalString (config.catppuccin.accent == "lavender") " Lavender"
            }";
          };
          general.avatarImage = builtins.path {
            name = "profile-pic";
            path = self + /modules/users/${config.home.username}/pfp.jpg;
            recursive = false;
          };
          uifontDefault = "JetBrainsMono Nerd Font";
          location = {
            name = config.invisible.location;
            showWeekNumberInCalendar = false;
          };
          idle.enabled = false;
          wallpaper.overviewEnabled = true;
          appLauncher.enableClipboardHistory = true;
          systemMonitor = {
            useCustomColors = true;
            warningColor = "#fab387";
            criticalColor = "#f38ba8";
          };
          dock.enabled = false;
          bar = {
            position = "left";
            widgets = {
              left = [
                { id = "Launcher"; }
                {
                  id = "Clock";
                  useMonospacedFont = true;
                }
                { id = "SystemMonitor"; }
                { id = "MediaMini"; }
              ];
              center = lib.singleton {
                hideUnoccupied = true;
                id = "Workspace";
                labelMode = "none";
              };
            };
          };
        };
      };
    };
}
