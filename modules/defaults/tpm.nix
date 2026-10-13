toplevel@{ den, ... }:
{
  den = {
    schema.host.options.hasTPM = toplevel.lib.mkEnableOption "Machine has a TPM";

    default = {
      includes = [ den.aspects.tpm2 ];

      _.to-users = { user, ... }: {
        user =
          { config, lib, ... }:
          lib.optionalAttrs user.isAdmin {
            extraGroups = lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
          };
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
