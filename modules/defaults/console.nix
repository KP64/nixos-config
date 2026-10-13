{
  den.default.nixos = { host, ... }: {
    console = {
      enable = host.isUsedInteractively;
      useXkbConfig = true;
    };
  };
}
