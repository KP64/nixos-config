toplevel@{ moduleWithSystem, ... }:
let
  hostName = "sindbad";
in
{
  perSystem.topology.modules = toplevel.lib.singleton (
    { config, ... }:
    let
      topologyLib = config.lib.topology;
      inherit (toplevel.config.lib.flake.util) getIcon;
    in
    {
      nodes.${hostName} = {
        deviceType = "device";
        deviceIcon = getIcon {
          file = "arch.svg";
          type = "topology";
        };
        interfaces."wlan0" = {
          physicalConnections = [ (topologyLib.mkConnection "router" "wifi") ];
          network = "home";
        };
        hardware = {
          info = "Lenovo Yoga 370";
          image = getIcon {
            file = "lenovo-yoga-370.png";
            type = "topology";
          };
        };
      };
    }
  );

  flake.modules.homeManager."kg@${hostName}" = moduleWithSystem (
    { inputs', ... }:
    { config, pkgs, ... }:
    {
      imports = with toplevel.config.flake.modules.homeManager; [
        desktop

        users-kg
        users-kg-firefox
        users-kg-glance
        users-kg-anki
        users-kg-hyprland
        users-kg-kitty
        users-kg-noctalia-shell
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

      programs =
        let
          inherit (config.lib.nixGL) wrap;
        in
        {
          noctalia-shell.package = wrap inputs'.noctalia.packages.default;
          kitty.package = wrap pkgs.kitty;
        };

      # NOTE: Works with HM, but:
      #   - SDDM won't find it.
      #   - pacman installed portal doesn't work with HM hyprland
      wayland.windowManager.hyprland = {
        package = null;
        portalPackage = null;
      };
    }
  );
}
