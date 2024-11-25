{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.cemu.enable = lib.mkEnableOption "Cemu";

  config = lib.mkIf config.gaming.emulators.cemu.enable {
    home-manager.users.${username}.home.packages = [ pkgs.cemu ];

    environment.persistence."/persist".users.${username}.directories = lib.optional config.system.impermanence.enable ".config/Cemu";
  };
}
