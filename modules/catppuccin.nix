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
  };

  den = {
    default = {
      nixos = { config, lib, ... }: {
        imports = [ inputs.catppuccin.nixosModules.catppuccin ];
        catppuccin.autoEnable = lib.mkDefault config.catppuccin.enable;
      };
      homeManager = { config, lib, ... }: {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];
        catppuccin.autoEnable = lib.mkDefault config.catppuccin.enable;
      };
    };

    aspects.catppuccin =
      { host, lib, ... }:
      lib.optionalAttrs (host.isUsedInteractively && !host.isServer) {
        nixos = { config, ... }: {
          catppuccin = {
            enable = true;
            cache.enable = true;
            inherit accent;
            cursors = {
              inherit (config.programs.niri) enable;
              accent = cursorAccent;
            };
          };
        };

        homeManager =
          {
            nixosConfig ? null,
            config,
            ...
          }:
          {
            catppuccin = {
              enable = true;
              cache.enable = nixosConfig == null;
              inherit accent;
              firefox.force = true;
              cursors = {
                inherit (config.wayland.windowManager.niri) enable;
                accent = cursorAccent;
              };
              thunderbird.profile = config.home.username;
            };

            gtk.colorScheme = "dark";
            qt.style.name = "kvantum";
          };
      };
  };
}
