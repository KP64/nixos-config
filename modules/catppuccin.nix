{ inputs, ... }:
let
  accent = "lavender";
in
{
  flake.modules = {
    nixos.catppuccin = {
      imports = [ inputs.catppuccin.nixosModules.catppuccin ];

      catppuccin = {
        enable = true;
        cache.enable = true;
        inherit accent;
      };
    };

    homeManager.catppuccin = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        inherit accent;
        # TODO: Activate when config.flake.modules.desktop is imported
        gtk.icon.enable = true;
        cursors = {
          enable = true;
          # TODO: Try out lavender
          accent = "dark";
        };
      };

      # TODO: Needed?
      # gtk.colorScheme = "dark";
      # home.pointerCurosr.hyprcursor.enable = true;
      # qt =
      #   let
      #     name = "kvantum";
      #   in
      #   {
      #     style = { inherit name; };
      #     platformTheme = { inherit name; };
      #   };
    };
  };
}
