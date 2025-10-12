{
  config,
  lib,
  inputs,
  ...
}:
let
  infix = "@";
  additionalHosts = import ./_additional_hosts.nix;
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeConfigurations =
    config.flake.modules.homeManager
    |> lib.filterAttrs (name: _: name |> lib.hasInfix infix)
    |> lib.mapAttrs' (
      userHost: module:
      let
        split = userHost |> lib.splitString infix;
        username = split |> builtins.head;
        hostname = split |> lib.last;

        host = additionalHosts.${hostname};
      in
      {
        name = userHost;
        value = inputs.home-manager.lib.homeManagerConfiguration {
          pkgs = import inputs.nixpkgs { inherit (host) system; };
          modules = [
            # TODO: Move this to users
            inputs.nur.modules.homeManager.default
            module
          ]
          ++ host.modules
          ++ [
            {
              programs.home-manager.enable = true;
              home = {
                inherit username;
                homeDirectory = "/home/${username}";
              };
            }
          ];
        };
      }
    );

  flake.checks =
    config.flake.homeConfigurations
    |> lib.mapAttrsToList (
      name: home: {
        ${home.pkgs.stdenv.hostPlatform.system}."homeConfigurations-${name}" = home.activationPackage;
      }
    )
    |> lib.mkMerge;
}
