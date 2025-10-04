toplevel: {
  # FIXME: Fonts aren't working. Even with fontconfig enabled :/
  flake.modules.homeManager."kg@sindbad" = {
    imports = with toplevel.config.flake.modules.homeManager; [
      desktop
      users-kg
    ];

    wayland.windowManager.hyprland.portalPackage = null;

    # TODO: Revert once https://github.com/nix-community/home-manager/issues/7027 is fixed
    #       This will need the user to install hyprlock via pacman
    programs.hyprlock.package = null;
  };
}
