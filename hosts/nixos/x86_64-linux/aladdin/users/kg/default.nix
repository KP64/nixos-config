{ config, ... }:
{
  users.users.kg = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/kg/password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMH6w/Q19oTmsf88Sksonk5A07wcNAloXaChlsKIEO83 tp@sindbad"
    ];
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
      "tss"
      "docker"
      "podman"
      "vboxusers"
    ];
  };
}
