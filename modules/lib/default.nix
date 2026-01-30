{ inputs, ... }:
{
  # TODO: Tests
  imports = [ inputs.nlib.flakeModules.default ];

  nlib.enable = true;
}
