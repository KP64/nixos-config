{ lib, config, ... }:
{
  options.system.security.tpm.enable = lib.mkEnableOption "TPM";

  config = lib.mkIf config.system.security.tpm.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
    };
  };
}
