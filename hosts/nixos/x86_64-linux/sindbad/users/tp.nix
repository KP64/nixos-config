{
  isNormalUser = true;
  password = "12345";
  openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAD+mYDOwD6lR89dpPCprEDTBIBNKgjzb6sqoGCHOYl7 kg@LapT"
  ];
  extraGroups = [
    "networkmanager"
    "wheel"
    "input"
    "kvm"
    "libvirtd"
    "audio"
    "video"
    "tss"
  ];
}
