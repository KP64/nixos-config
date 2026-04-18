{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_port_extension";
  version = "0.112.2";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Q5oaRuZ3fFtIoyY+HPGujm/bqU+udjK5lb4HfMlFrnA=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-j2Rpd5MkT7/9pG4dVn2/UTdbWvs1L6XHNFg/CO1D9QU=";

  meta = {
    description = "A nushell plugin to list all active connections and scanning ports on a target address (replacement of both nu_plugin_port_scan and nu_plugin_port_list since 0.102";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_port_extension";
  };
})
