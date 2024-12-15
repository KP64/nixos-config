{
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.gaming.mangohud;
in
{
  options.gaming.mangohud.enable = lib.mkEnableOption "Mangohud Overlay";

  config.home-manager.users.${username}.programs.mangohud = { inherit (cfg) enable; };
}
