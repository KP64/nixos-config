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
        autoEnable = true;
        cache.enable = true;
        inherit accent;
        cursors = {
          enable = true;
          accent = cursorAccent;
        };
      };
    };

    homeManager =
      {
        osConfig ? null,
        config,
        ...
      }:
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        catppuccin = {
          enable = true;
          autoEnable = true;
          cache.enable = osConfig == null;
          inherit accent;
          firefox.force = true;
          cursors = {
            enable = config.programs.niri.enable or false;
            accent = cursorAccent;
          };
          thunderbird.profile = config.home.username;
        };

        gtk.colorScheme = "dark";
        qt.style.name = "kvantum";
      };
  };
}
