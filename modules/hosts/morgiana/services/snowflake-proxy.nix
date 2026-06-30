{
  den.aspects.morgiana.nixos = {
    services.snowflake-proxy = {
      enable = true;
      capacity = 4;
    };
  };
}
