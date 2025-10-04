{ inputs, ... }:
{
  # Allow graphical applications like hyprland to be wrapped
  # on non NixOS systems. This allows them to run correctly.
  flake.modules.homeManager.wrap-graphics = {
    nixGL = { inherit (inputs.nixGL) packages; };
  };
}
