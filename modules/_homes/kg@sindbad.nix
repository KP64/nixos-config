toplevel:
let
  hostName = "sindbad";
in
{
  perSystem.topology.modules =
    let
      inherit (toplevel.config.lib.flake.util) getAsset;
    in
    [
      {
        nodes.${hostName} = {
          deviceType = "device";
          deviceIcon = getAsset {
            file = "arch.svg";
            type = "topology";
            sha256 = "sha256-76ibPfvW5G18NMH3WFV6yoDzgSV89XpIb9seMabt0BY=";
          };
          interfaces.wlan0.network = "home";
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
    ];

  den = {
    homes.x86_64-linux."kg@${hostName}" = {
      isGamingCapable = true;
      isGraphical = true;
      isServer = false;
      isUsedInteractively = true;
    };
    aspects."kg@${hostName}" = {
      homeManager = {
        targets.genericLinux.enable = true;
        programs.home-manager.enable = true;
      };
    };
  };
}
