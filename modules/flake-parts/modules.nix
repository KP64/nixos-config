{ inputs, ... }:
{
  # This is the MVP. It allows for the modularization of flake-parts.
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
