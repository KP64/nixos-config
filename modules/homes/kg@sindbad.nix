toplevel: {
  # FIXME: Fonts aren't working. Even with fontconfig enabled :/
  flake.modules.homeManager."kg@sindbad" =
    { config, pkgs, ... }:
    {
      imports = with toplevel.config.flake.modules.homeManager; [
        desktop
        users-kg
      ];

      programs.kitty.package = config.lib.nixGL.wrap pkgs.kitty;

      # NOTE: Works with HM, but:
      #   - SDDM won't find it.
      #   - pacman installed portal doesn't work with HM hyprland
      wayland.windowManager.hyprland = {
        package = null;
        portalPackage = null;
      };

      # TODO: Revert once https://github.com/nix-community/home-manager/issues/7027 is fixed
      #       This will need the user to install hyprlock via pacman
      programs.hyprlock.package = null;
    };
}
