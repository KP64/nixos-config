{
  den.aspects.kg.homeManager = { host, ... }: {
    programs.prismlauncher.enable = host.isGamingCapable;
  };
}
