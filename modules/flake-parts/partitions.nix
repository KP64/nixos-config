{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.partitions ];

  /*
    Partitions define "sub flakes", whose inputs
    and results will not be shown in a consumers' flake.
    This is useful to compartmentalize flakes into more
    specialised units.
    An example would be a development flake that handles
    everything about further developing this flake like formatters etc.
  */
  partitions.dev =
    let
      devPath = ../../dev;
    in
    {
      # This will use "${self}/dev/flake.nix"
      extraInputsFlake = devPath;
      module = { inherit (inputs.import-tree (devPath + /modules)) imports; };
    };

  # Moving dev related stuff to the appropriate partition
  partitionedAttrs = {
    checks = "dev";
    devShells = "dev";
    formatter = "dev";
  };
}
