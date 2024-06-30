{ username, stateVersion, ... }:

{
  # TODO: catppuccin cursors not necessarily available
  home = {
    inherit username stateVersion;
    homeDirectory = "/home/${username}";
    pointerCursor = {
      gtk.enable = true;
      x11 = {
        enable = true;
        defaultCursor = "catppuccin-mocha-dark-cursors";
      };
      size = 24;
    };
  };

  programs.home-manager.enable = true;
}
