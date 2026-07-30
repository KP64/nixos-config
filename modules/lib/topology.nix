{ config, moduleWithSystem, ... }: {
  den.aspects.customLib.nixos = moduleWithSystem (
    { system, ... }: { lib, ... }: {
      nix-lib.lib.topology =
        let
          inherit (config.flake.topology.${system}.config.networks) home;
        in
        {
          getHomeCidr4 = {
            type = with lib.types; functionTo nonEmptyStr;
            fn =
              home.cidrv4
              |> lib.splitString "/"
              |> builtins.head
              |> lib.removeSuffix ".0";
            description = "Returns the IPv4 Network Prefix of the home Network";
          };
          getHomeCidr6 = {
            type = with lib.types; functionTo nonEmptyStr;
            fn =
              home.cidrv6
              |> lib.splitString "/"
              |> builtins.head
              |> lib.removeSuffix "::";
            description = "Returns the IPv6 Network Prefix of the home Network";
          };
        };
    }
  );
}
