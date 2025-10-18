{ inputs, ... }:
{
  /*
    Every system this flake supports
    and for which `perSystem` will run.
    `flakeExposed` returns ALL systems
    supported by Nix
  */
  systems = inputs.nixpkgs.lib.systems.flakeExposed;
}
