{ config, ... }:
{
  users.users.kg = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/kg/password".path;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };
}
