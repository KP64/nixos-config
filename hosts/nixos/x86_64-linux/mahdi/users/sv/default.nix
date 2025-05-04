{ config, ... }:
{
  users.users.sv = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/sv/password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIrSdp7fuNVACY8WmNg9jJ6Z71Vcx3idqlMzWbeyAc7e kg@aladdin"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMH6w/Q19oTmsf88Sksonk5A07wcNAloXaChlsKIEO83 tp@sindbad"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
    ];
  };
}
