{ nixpkgs, inputs }:

let
  # -- DESC --
  # Recurses the attrsets until the name-value-pair is not an attrset
  # Then appends on it the concatenated paths (names)
  # -- CODE --
  # browser.discovery.enabled = false;
  # turns to
  # browser.discovery.enabled."browser.discovery.enabled" = false;
  replaceLastWithFullPath =
    attrs:
    nixpkgs.lib.mapAttrsRecursiveCond builtins.isAttrs (name: value: {
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
        nixpkgs.lib.foldlAttrs (
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
    }:
    let
      stateVersion = "24.05";
    in
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit
          inputs
          username
          stateVersion
          replaceLastWithFullPath
          collectLastEntries
          ;
      };
      modules =
        with inputs;
        [
          nixos-wsl.nixosModules.default
          home-manager.nixosModules.default
        ]
        ++ [
          ./hosts/${username}/configuration.nix
          ./desktop
          ./hardware
          ./programs
          ./system
          {
            nixpkgs.overlays = [ inputs.nur.overlay ];
            wsl = {
              enable = wsl;
              defaultUser = username;
              useWindowsDriver = true;
            };
            home-manager = {
              extraSpecialArgs = {
                inherit username stateVersion;
              };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = [ ./system/home-manager.nix ];
            };
          }
        ];
    };
}
