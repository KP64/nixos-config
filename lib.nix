{ inputs }:
let
  inherit (inputs.nixpkgs) lib;

  # -- DESC --
  # Recurses the attrsets until the name-value-pair is not an attrset
  # Then appends on it the concatenated paths (names)
  # -- CODE --
  # browser.discovery.enabled = false;
  # turns to
  # browser.discovery.enabled."browser.discovery.enabled" = false;
  appendLastWithFullPath =
    attrs:
    lib.mapAttrsRecursiveCond builtins.isAttrs (name: value: {
      ${builtins.concatStringsSep "." name} = value;
    }) attrs;

  # -- DESC --
  # Takes the last entry of each (nested) attrset and
  # collects them into a new set
  # -- CODE --
  # browser.discovery.enabled."browser.discovery.enabled" = false;
  # turns to
  # { "browser.discovery.enabled" = false; }
  collectLastEntries =
    attrs:
    rec {
      flatten =
        set:
        let
          processAttr = name: value: if builtins.isAttrs value then flatten value else { "${name}" = value; };
        in
        lib.foldlAttrs (
          acc: name: value:
          acc // processAttr name value
        ) { } set;

      result = flatten attrs;
    }
    .result;
in
{
  mkSystem =
    {
      username,
      system,
      wsl ? false,
      pi ? false,
    }:
    let
      stable-pkgs = inputs.nixpkgs-stable.legacyPackages.${system};
      invisible = import "${inputs.nix-invisible}/globals.nix";
    in
    lib.nixosSystem {
      inherit system;
      specialArgs = {
        stateVersion = "24.11";
        inherit
          inputs
          stable-pkgs
          invisible
          username
          wsl
          appendLastWithFullPath
          collectLastEntries
          ;
      };
      modules =
        (with inputs; [
          nix-topology.nixosModules.default
          disko.nixosModules.disko
        ])
        ++ lib.optionals pi (
          with inputs.raspberry-pi-nix.nixosModules;
          [
            raspberry-pi
            sd-image
          ]
        )
        ++ [
          ./hosts/${username}/configuration.nix
          ./desktop
          ./hardware
          ./programs
          ./services
          ./system
          {
            nixpkgs.overlays = [ inputs.nur.overlays.default ];
            users = {
              mutableUsers = false;
              users.${username} = {
                isNormalUser = true;
                description = username;
              };
            };
          }
        ];
    };
}
