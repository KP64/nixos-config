{ inputs, ... }:
{
  # TODO: Auto add DiskoConfigurations to equivalent host if available
  imports = [ inputs.disko.flakeModules.default ];
}
