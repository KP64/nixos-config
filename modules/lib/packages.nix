{
  flake.modules.homeManager.customLib =
    { config, lib, ... }:
    {
      nix-lib.lib.packages = {
        activatePerHosts = {
          type = with lib.types; functionTo (listOf package);
          fn =
            list:
            list
            |> map (
              { packages, hosts }:
              hosts
              |> map (host: host.config.networking.hostName or host.networkName)
              |> builtins.elem config.hostname
              |> lib.flip lib.optionals packages
            )
            |> lib.flatten;
          description = ''
            Returns a list of Home-Manager packages
            to include in the corresponding hosts.
          '';
        };
      };
    };
}
