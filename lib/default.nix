{ inputs, rootPath }:
let
  systems = import ./systems.nix { inherit inputs rootPath; };
  utils = import ./utils.nix { inherit inputs; };
in
{
  inherit (systems) getHosts getHomes getUsers;
  inherit (utils) collectLastEntries appendLastWithFullPath;
}
