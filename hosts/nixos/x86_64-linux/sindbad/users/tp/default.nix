{ config, ... }:
{
  users.users.tp = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/tp/password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrSdp7fuNVACY8WmNg9jJ6Z71Vcx3idqlMzWbeyAc7e kg@aladdin"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
      "tss"
    ];
  };
}
