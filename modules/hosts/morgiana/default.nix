{ den, inputs, ... }:
{
  den = {
    hosts.aarch64-linux.morgiana.users.kg = { };

    aspects.morgiana = {
      includes = with den.aspects; [
        rpi-cache
        rpi-rtc
        ssh
      ];
      nixos =
        { config, ... }:
        let
          inherit (inputs) nixos-raspberrypi;
        in
        {
          imports = [
            inputs.nix-invisible.modules.nixos.host-morgiana
          ]
          ++ (with nixos-raspberrypi.lib; [
            inject-overlays
            # TODO: Inject when packages aren't broken
            # inject-overlays-global
          ])
          ++ (with nixos-raspberrypi.nixosModules; [
            nixpkgs-rpi
            raspberry-pi-4.base
          ]);

          home-manager.users.kg.home = { inherit (config.system) stateVersion; };

          system.stateVersion = "26.05";
          hardware.facter.reportPath = ./facter.json;

          console.keyMap = "de";

          sops.defaultSopsFile = ./secrets.yaml;
          users.users.root.password = config.sops.secrets.kg_password.path;
        };
    };
  };
}
