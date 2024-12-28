{
  imports = [
    ./immich.nix
    ./jellyfin.nix
    ./redlib.nix
  ];

  users.groups.multimedia = { };

  # TODO: This is for future *arr Services
  systemd.tmpfiles.rules = [
    "d /data - - - - -"
    "d /data/media 0770 - multimedia - -"
  ];
}
