{
  imports = [
    ./dumb.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./komga.nix
    ./neuters.nix
    ./redlib.nix
    ./stirling-pdf.nix
  ];

  users.groups.multimedia = { };

  # TODO: This is for future *arr Services
  systemd.tmpfiles.rules = [
    "d /data - - - - -"
    "d /data/media 0770 - multimedia - -"
  ];
}
