{ inputs, lib, ... }:
let
  devPartition = "dev";
in
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
  partitions.${devPartition} =
    let
      devPath = ../../dev;
    in
    {
      extraInputsFlake = devPath;
      module = inputs.import-tree (lib.path.append devPath "modules");
    };

  # Moving dev related stuff to the appropriate partition
  partitionedAttrs = lib.genAttrs [ "checks" "devShells" "formatter" ] (_: devPartition);
}
