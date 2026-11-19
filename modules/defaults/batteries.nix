{ den, ... }: {
  den = {
    schema.host.includes = [ den.batteries.mutual-provider ];
    default.includes = with den.batteries; [
      define-user
      hostname
      flake-scope
      inputs'
      self'
    ];
  };
}
