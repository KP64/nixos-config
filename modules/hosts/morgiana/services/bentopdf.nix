{
  den.aspects.morgiana.nixos = { config, ... }: {
    # TODO: Add Security headers. nixpkgs module is kind of broken
    services.bentopdf = {
      enable = true;
      domain = "pdf.${config.networking.domain}";
      caddy.enable = true;
    };
  };
}
