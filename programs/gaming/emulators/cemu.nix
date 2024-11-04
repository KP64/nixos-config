{
  lib,
  config,
  pkgs,
  username,
  ...
}:
{
  options.gaming.emulators.cemu.enable = lib.mkEnableOption "Enables Cemu";

  config = lib.mkIf config.gaming.emulators.cemu.enable {
    home-manager.users.${username}.home.packages = [ pkgs.cemu ];
    environment.persistence."/persist".users.${username}.directories = [ 
      ".config/Cemu"
    ];
  };
}
