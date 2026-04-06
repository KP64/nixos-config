toplevel:
let
  hostName = "sindbad";
in
{
  perSystem.topology.modules = toplevel.lib.singleton (
    { config, ... }:
    let
      topologyLib = config.lib.topology;
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    {
      nodes.${hostName} = {
        deviceType = "device";
        deviceIcon = getAsset {
          file = "arch.svg";
          type = "topology";
        };
        interfaces."wlan0" = {
          physicalConnections = [ (topologyLib.mkConnection "router" "wifi") ];
          network = "home";
        };
        hardware = {
          info = "Lenovo Yoga 370";
          image = getAsset {
            file = "lenovo-yoga-370.png";
            type = "topology";
          };
        };
      };
    }
  );

  flake.modules.homeManager."kg@${hostName}" =
    { pkgs, ... }:
    {
      imports = with toplevel.config.flake.modules.homeManager; [
        desktop

        users-kg
        users-kg-anki
        users-kg-firefox
        users-kg-glance
        users-kg-kitty
        users-kg-niri
        users-kg-noctalia-shell
        users-kg-thunderbird
        users-kg-ttyper
      ];

      home = {
        stateVersion = "26.05";
        packages = with pkgs; [
          impala
          noto-fonts-color-emoji # Needed for icons
        ];
      };
    };
}
