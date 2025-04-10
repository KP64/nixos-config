{
  users.users.ws = {
    password = "12345";
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
  };
}
