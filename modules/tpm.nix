{
  den.aspects.tpm = {
    nixos = {
      security.tpm2 = {
        enable = true;
        abrmd.enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
      };
    };

    _.to-users =
      { user, ... }:
      {
        nixos =
          { config, ... }:
          {
            users.users.${user.name}.extraGroups = [ config.security.tpm2.tssGroup ];
          };
        homeManager.services.ssh-tpm-agent.enable = true;
      };
  };
}
