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

  den.aspects.catppuccin =
    { host, lib, ... }:
    lib.optionalAttrs host.isUsedInteractively {
      nixos = { config, ... }: {
        imports = [ inputs.catppuccin.nixosModules.catppuccin ];

        catppuccin = {
          enable = true;
          autoEnable = true;
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
          imports = [ inputs.catppuccin.homeModules.catppuccin ];

          catppuccin = {
            enable = true;
            autoEnable = true;
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
}
