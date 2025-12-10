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

    homeManager.catppuccin = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        cache.enable = true;
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
