{ pkgs, inputs, ... }:

{
  nix.gc.automatic = true;

  imports = [
    ../../home-manager
  ];

  catppuccin = {
    enable = true;
    flavour = "mocha";
  };

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
      name = "Catppuccin-Mocha-Dark-Cursors";
      size = 24; # catppuccin cursor sizes: 24, 32, 48, 64
    };
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "~/.steam/root/compatibilitytools.d";
    };
  };

  gtk = {
    enable = true;
    # Catppuccin cursor is mauve by default
    catppuccin.cursor.accent = "dark";
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
