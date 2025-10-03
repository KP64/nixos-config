toplevel: {
  flake.modules.homeManager."kg@sindbad" = {
    imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

    # TODO: Revert once https://github.com/nix-community/home-manager/issues/7027 is fixed
    programs.hyprlock.package = null;
    # TODO: add this once the above is fixed
    #       -> That is the only blocker for why it
    #          is not installed by Home-Manager
    # wayland.windowManager.hyprland = {
    #   package = nixGL.wrap pkgs.hyprland;
    # };
  };
}
