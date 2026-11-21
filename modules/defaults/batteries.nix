{ den, ... }: {
  den = {
    # TODO: Remove after 2027-01-01
    migrations.user-host-content.acknowledged = true;

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
