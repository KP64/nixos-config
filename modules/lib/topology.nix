{ config, moduleWithSystem, ... }:
{
  den.aspects.customLib.nixos = moduleWithSystem (
    { system, ... }: { lib, ... }: {
      nix-lib.lib.topology.getHomeCidr = {
        type = with lib.types; functionTo nonEmptyStr;
        fn =
          config.flake.topology.${system}.config.networks.home.cidrv6
          |> lib.splitString "/"
          |> builtins.head
          |> lib.removeSuffix "::";
        description = ''
          Returns the IPv6 Network Prefix of the home Network.
        '';
      };
    }
  );
}
