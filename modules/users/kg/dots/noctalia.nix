toplevel@{ self, inputs, ... }:
{
  flake-file.inputs.noctalia = {
    type = "github";
    owner = "noctalia-dev";
    repo = "noctalia-shell";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      noctalia-qs.inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "";
      };
    };
  };

  den.aspects.kg._.noctalia-shell.homeManager =
    {
      osConfig ? null,
      config,
      lib,
      ...
    }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".cache/noctalia/wallpapers.json" = lib.mkIf config.programs.noctalia-shell.enable {
        text = builtins.toJSON {
          defaultWallpaper = toplevel.config.lib.flake.util.getAsset {
            file = "cabin.png";
            type = "wallpapers/catppuccin";
            sha256 = "sha256-UKm2+z2ASkAS8w+0ukJ6Pa6gTysd1YCVszkZPXLkVKo=";
          };
        };
      };

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
            path = "${self}/modules/users/${config.home.username}/pfp.jpg";
            recursive = false;
            sha256 = "sha256-Ah71B03bSn7MeHt/weKxp6aKoXxSre/ncXsCJ4MzLfg=";
          };
          uifontDefault = "JetBrainsMono Nerd Font";
          location = {
            name = config.invisible.location;
            showWeekNumberInCalendar = false;
          };
          # PAM doesn't work when hm-only.
          idle.enabled = osConfig != null;
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
