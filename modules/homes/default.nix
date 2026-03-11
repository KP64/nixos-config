{
  config,
  lib,
  inputs,
  withSystem,
  ...
}:
let
  infix = "@";
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake = {
    homeConfigurations =
      config.flake.modules.homeManager
      |> lib.filterAttrs (name: _: lib.hasInfix infix name)
      |> lib.mapAttrs' (
        userHost: module:
        let
          userHostSplit = lib.splitString infix userHost;
          username = builtins.head userHostSplit;
          hostname = lib.last userHostSplit;
        in
        {
          name = userHost;
          value = withSystem config.additionalHosts.${hostname}.system (
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
