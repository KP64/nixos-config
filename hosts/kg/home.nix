{ username, stateVersion, ... }:

{
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        # TODO: catppuccin cursors not necessarily available
        defaultCursor = "catppuccin-mocha-dark-cursors";
      };
      size = 24;
    };
  };

  programs.home-manager.enable = true;
}
