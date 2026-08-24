toplevel@{ den, lib, ... }:
let
  hostName = "sindbad";
in
{
  perSystem.topology.modules = [
    (
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
            sha256 = "sha256-76ibPfvW5G18NMH3WFV6yoDzgSV89XpIb9seMabt0BY=";
          };
          interfaces.wlan0 = {
            physicalConnections = [ (topologyLib.mkConnection "router" "wifi") ];
            network = "home";
          };
          hardware = {
            info = "Lenovo Yoga 370";
            image = getAsset {
              file = "lenovo-yoga-370.png";
              type = "topology";
              sha256 = "sha256-uboIdVKu4VvF1rcClUG3awJrZTjIihZ0gJTwC6N5yKs=";
            };
          };
        };
      }
    )
  ];

  # TODO: Find a way to do this more elegant
  den = {
    homes.x86_64-linux."kg@${hostName}" = { };
    aspects.kg = { host, ... }: {
      includes = lib.optionals (host.name == hostName) (
        [ den.aspects.desktop ]
        ++ (with den.aspects.kg._; [
          anki
          firefox
          fonts
          glance
          kitty
          niri
          noctalia
          thunderbird
          ttyper
        ])
      );

      homeManager = lib.mkIf (host.name == hostName) {
        targets.genericLinux.enable = true;
        programs.home-manager.enable = true;
        home.stateVersion = "26.11";
      };
    };
  };
}
