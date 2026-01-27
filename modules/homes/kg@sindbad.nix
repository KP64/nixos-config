toplevel@{ customLib, ... }:
let
  hostName = "sindbad";
in
{
  perSystem.topology.modules = toplevel.lib.singleton (
    { config, ... }:
    let
      topologyLib = config.lib.topology;
    in
    {
      nodes.${hostName} = {
        deviceType = "device";
        deviceIcon = customLib.util.getIcon {
          file = "arch.svg";
          type = "topology";
        };
        interfaces."wlan0" = {
          physicalConnections = [ (topologyLib.mkConnection "router" "wifi") ];
          network = "home";
        };
        hardware = {
          info = "Lenovo Yoga 370";
          image = customLib.util.getIcon {
            file = "lenovo-yoga-370.png";
            type = "topology";
          };
        };
      };
    }
  );

  flake.modules.homeManager."kg@${hostName}" =
    { config, pkgs, ... }:
    {
      imports = with toplevel.config.flake.modules.homeManager; [
        desktop

        users-kg
        users-kg-firefox
        users-kg-glance
        users-kg-anki
        users-kg-hypridle
        users-kg-hyprland
        users-kg-hyprlock
        users-kg-hyprpanel
        users-kg-hyprpaper
        users-kg-kitty
        users-kg-rofi
        users-kg-thunderbird
        users-kg-vesktop
      ];

      home = {
        stateVersion = "25.11";
        packages = with pkgs; [
          impala
          noto-fonts-color-emoji # Needed for icons
        ];
      };

      targets.genericLinux.enable = true;

      services.network-manager-applet.enable = true;

      programs = {
        kitty.package = config.lib.nixGL.wrap pkgs.kitty;

        # TODO: Revert once https://github.com/nix-community/home-manager/issues/7027 is fixed
        #       This will need the user to install hyprlock via pacman
        hyprlock.package = null;
      };

      # NOTE: Works with HM, but:
      #   - SDDM won't find it.
      #   - pacman installed portal doesn't work with HM hyprland
      wayland.windowManager.hyprland = {
        package = null;
        portalPackage = null;
      };
    };
}
