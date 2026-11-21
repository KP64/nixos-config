{ lib, ... }: {
  den = {
    aspects.tpm.nixos = {
      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
      };
    };

    schema.user.includes = [
      (
        { user, ... }:
        lib.optionalAttrs user.isAdmin {
          user = { config, lib, ... }: {
            extraGroups = lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
          };
          homeManager =
            {
              nixosConfig ? null,
              lib,
              ...
            }:
            lib.mkIf (nixosConfig.security.tpm2.enable or false) { services.ssh-tpm-agent.enable = true; };
        }
      )
    ];
  };
}
