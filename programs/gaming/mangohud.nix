{
  lib,
  config,
  username,
  ...
}:
{
  options.gaming.mangohud.enable = lib.mkEnableOption "Enables Mangohud Overlay";

  config = lib.mkIf config.gaming.mangohud.enable {
    home-manager.users.${username}.programs.mangohud.enable = true;
  };
}
