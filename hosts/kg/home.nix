{ pkgs, inputs, ... }:

{
  nix.gc.automatic = true;

  imports = [ ../../home-manager ];

  catppuccin.enable = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        inputs.xdg-desktop-portal-hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };
    };
  };

  home = {
    stateVersion = "24.05";
    username = "kg";
    homeDirectory = "/home/kg";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.mochaDark;
      name = "catppuccin-mocha-dark-cursors";
      x11 = {
        enable = true;
        defaultCursor = "catppuccin-mocha-dark-cursors";
      };
      size = 24;
    };
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;

  };

  qt.enable = true;

  services = {
    copyq.enable = true;
    udiskie.enable = true;
    pueue.enable = true;
    mako = {
      enable = true;
      defaultTimeout = 5000;
    };
    network-manager-applet.enable = true;
    blueman-applet.enable = true;
  };

  programs.home-manager.enable = true;
}
