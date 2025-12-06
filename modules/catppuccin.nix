{ inputs, ... }:
let
  accent = "lavender";
  cursorAccent = "dark";
in
{
  flake.modules = {
    nixos.catppuccin =
      { pkgs, ... }:
      {
        imports = [ inputs.catppuccin.nixosModules.catppuccin ];

        services.displayManager.sddm.package = pkgs.kdePackages.sddm;

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

    homeManager.catppuccin =
      {
        osConfig ? null,
        ...
      }:
      {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        catppuccin = {
          enable = true;
          # NOTE: Only include if home-manager isn't used as a module
          cache.enable = osConfig == null;
          inherit accent;
          firefox.force = true;
          cursors = {
            enable = true;
            accent = cursorAccent;
          };
        };

        gtk.colorScheme = "dark";
        qt.style.name = "kvantum";
      };
  };
}
