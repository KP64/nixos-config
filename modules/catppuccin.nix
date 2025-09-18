{ inputs, ... }:
let
  accent = "lavender";
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
        };
      };

    homeManager.catppuccin = {
      imports = [ inputs.catppuccin.homeModules.catppuccin ];

      catppuccin = {
        enable = true;
        inherit accent;
        firefox.force = true;
        cursors = {
          enable = true;
          accent = "dark";
        };
      };

      gtk.colorScheme = "dark";
      qt =
        let
          name = "kvantum";
        in
        {
          style = { inherit name; };
          platformTheme = { inherit name; };
        };
    };
  };
}
