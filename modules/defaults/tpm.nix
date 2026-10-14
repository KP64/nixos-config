toplevel@{ den, ... }:
{
  den = {
    schema.host.options.hasTPM = toplevel.lib.mkEnableOption "Machine has a TPM";

    default = {
      includes = [ den.aspects.tpm2 ];

      _.to-users =
        { user, lib, ... }:
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
        };
    };
    aspects.tpm2 =
      { host, lib, ... }:
      lib.optionalAttrs host.hasTPM {
        nixos = {
          security.tpm2 = {
            enable = true;
            pkcs11.enable = true;
            tctiEnvironment.enable = true;
          };
        };
      };
  };
}
