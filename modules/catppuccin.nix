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
            # only actually enabled when desktopManager.gnome or
            # displayManager.gdm are enabled
            enable = true;
            accent = cursorAccent;
          };
        };
      };

    homeManager.catppuccin =
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
