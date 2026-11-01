{ lib, ... }: {
  den.schema = {
    host = {
      options.hasTPM = lib.mkEnableOption "Machine has a TPM";
      includes = [
        (
          { host, ... }:
          lib.optionalAttrs host.hasTPM {
            nixos = {
              security.tpm2 = {
                enable = true;
                pkcs11.enable = true;
                tctiEnvironment.enable = true;
              };
            };
          }
        )
      ];
    };

    user.includes = [
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
