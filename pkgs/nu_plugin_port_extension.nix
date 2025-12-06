{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_port_extension";
  version = "0.108.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    rev = "v${version}";
    hash = "sha256-LpbV3SeGUlWtb/Mk9W9NxNLPpOL3Kvaiy+mSF1AYM98=";
  };

  cargoHash = "sha256-jkKgsLm0bYcu6j6BO+Jr3zzNIud5ELFIQSxgbz959MA=";

  meta = {
    description = "A nushell plugin to list all active connections and scanning ports on a target address (replacement of both nu_plugin_port_scan and nu_plugin_port_list since 0.102";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
