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
          value = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { inherit (additionalHosts.${hostname}) system; };
            modules = [
              config.flake.modules.homeManager.nix-unfree
            ]
            ++ [ module ]
            ++ [
              config.flake.modules.homeManager.hostname
              { inherit hostname; }
            ]
            ++ [
              {
                # Allow graphical applications like hyprland to be wrapped
                # on non NixOS systems. This allows them to run correctly.
                # TODO: Instruction on how to genericLinux.gpu
                #       Benefits:
                #         - recommended method for graphical applications
                #         - Removes dependency on nixGL
                targets.genericLinux.nixGL = { inherit (inputs.nixGL) packages; };
              }
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
