{ config, lib, ... }:
let
  cfg = config.system.security.tpm;
in
{
  options.system.security.tpm.enable = lib.mkEnableOption "TPM";

  config.security.tpm2 = {
    inherit (cfg) enable;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };
}
