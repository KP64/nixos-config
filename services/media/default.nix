{
  imports = [
    ./dumb.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./jellyseerr.nix
    ./komga.nix
    ./neuters.nix
    ./redlib.nix
    ./stirling-pdf.nix
  ];

  users.groups.multimedia = { };

  # TODO: This is for future *arr Services
  # TODO: use following prometheus exporters when *arr implemented:
  # exportarr-{bazarr,lidarr,prowlarr,radarr,readarr,sonarr}
  systemd.tmpfiles.rules = [
    "d /data - - - - -"
    "d /data/media 0770 - multimedia - -"
  ];
}
