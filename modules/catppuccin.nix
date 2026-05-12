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
            enable = config.wayland.windowManager.hyprland.enable || config.programs.niri.enable;
            accent = cursorAccent;
          };
        };

        gtk.colorScheme = "dark";
        qt.style.name = "kvantum";
      };
  };
}
