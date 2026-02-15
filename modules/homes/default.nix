{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  infix = "@";
  additionalHosts = import ./_additional_hosts.nix;
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake = {
    homeConfigurations =
      config.flake.modules.homeManager
      |> lib.filterAttrs (name: _: name |> lib.hasInfix infix)
      |> lib.mapAttrs' (
        userHost: module:
        let
          userHostSplit = userHost |> lib.splitString infix;
          username = userHostSplit |> builtins.head;
          hostname = userHostSplit |> lib.last;
        in
        {
          name = userHost;
          value = withSystem additionalHosts.${hostname}.system (
            { pkgs, ... }:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules =
                (with config.flake.modules.homeManager; [
                  customLib
                  nix-unfree
                ])
                ++ [
                  module

                  inputs.nix-invisible.modules.homeManager.invisibility

                  config.flake.modules.homeManager.hostname
                  { inherit hostname; }

                  {
                    programs.home-manager.enable = true;
                    home = {
                      inherit username;
                      homeDirectory = "/home/${username}";
                    };
                  }
                ];
            }
          );
        }
      );

    checks =
      config.flake.homeConfigurations
      |> lib.mapAttrsToList (
        name: home: {
          ${home.pkgs.stdenv.hostPlatform.system}."homeConfigurations-${name}" = home.activationPackage;
        }
      )
      |> lib.mkMerge;
  };
}
