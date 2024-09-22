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
      pi ? false,
    }:
    nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        stateVersion = "24.11";
        inherit
          inputs
          username
          replaceLastWithFullPath
          collectLastEntries
          ;
      };
      modules =
        (with inputs; [
          nix-topology.nixosModules.default
          nixos-wsl.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
        ])
        ++ nixpkgs.lib.optional pi inputs.raspberry-pi-nix.nixosModules.raspberry-pi
        ++ [
          ./hosts/${username}/configuration.nix
          ./desktop
          ./hardware
          ./programs
          ./system
          {
            nixpkgs.overlays = with inputs; [
              nur.overlay
              nix-minecraft.overlay
            ];
            wsl = {
              enable = wsl;
              defaultUser = username;
              useWindowsDriver = true;
            };
          }
        ];
    };
}
