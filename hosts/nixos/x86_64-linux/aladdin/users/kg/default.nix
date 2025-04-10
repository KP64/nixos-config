{ config, ... }:
{
  users.users.kg = {
    isNormalUser = true;
    hashedPasswordFile = config.sops.secrets."users/kg/password".path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFqboCBFR7zCUKnUoIIXbYh42muPCKNXZ+g6cp/KXQaX tp@tp"
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
