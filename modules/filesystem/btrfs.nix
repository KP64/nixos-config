{
  den.aspects.fs._.btrfs.nixos = {
    services.btrfs.autoScrub = {
      enable = true;
      fileSystems = [ "/" ];
    };
  };
}
