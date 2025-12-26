{ inputs, moduleWithSystem, ... }:
let
  accent = "lavender";
  cursorAccent = "dark";
in
{
  # TODO: Refactor in favor of tags
  flake.modules = {
    nixos.catppuccin = moduleWithSystem (
      { system, ... }:
      { pkgs, ... }:
      {
        imports = [ inputs.catppuccin.nixosModules.catppuccin ];

        services.displayManager.sddm.package = pkgs.kdePackages.sddm;

        catppuccin = {
          enable = true;
          cache.enable = true;
          inherit accent;
          cursors = {
            enable = system != "aarch64-linux";
            accent = cursorAccent;
          };
        };
      }
    );

    homeManager.catppuccin = moduleWithSystem (
      { system, ... }:
      _: {
        imports = [ inputs.catppuccin.homeModules.catppuccin ];

        catppuccin = {
          enable = true;
          cache.enable = true;
          inherit accent;
          firefox.force = true;
          cursors = {
            enable = system != "aarch64-linux";
            accent = cursorAccent;
          };
        };

        gtk.colorScheme = "dark";
        qt.style.name = "kvantum";
      }
    );
  };
}
