{ inputs, ... }:
let
  accent = "lavender";
  cursorAccent = "dark";
in
{
  flake-file.inputs.catppuccin = {
    type = "github";
    owner = "catppuccin";
    repo = "nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.catppuccin = {
    nixos = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];

      catppuccin = {
        enable = true;
        cache.enable = true;
        inherit accent;
        cursors = {
          # only actually enabled when desktopManager.gnome or
          # displayManager.gdm are enabled
          enable = true;
          accent = cursorAccent;
        };
      };
    };

    homeManager =
      { config, ... }:
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        catppuccin = {
          enable = true;
          cache.enable = true;
          inherit accent;
          firefox.force = true;
          cursors = {
            enable = config.wayland.windowManager.hyprland.enable || (config.programs.niri.enable or false);
            accent = cursorAccent;
          };
        };

        gtk.colorScheme = "dark";
        qt.style.name = "kvantum";
      };
  };
}
