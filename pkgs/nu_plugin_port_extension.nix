{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_port_extension";
  version = "0.110.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    rev = "v${finalAttrs.version}";
    hash = "sha256-75zHJ3de5N+hoP0vrv6VgF81ZzkP/lVzyiZ+6R9WI94=";
  };

  cargoHash = "sha256-3vrKAyMqZIbmxC33Ib6RApYu6Bpt6oR2f5Zj17N08qQ=";

  meta = {
    description = "A nushell plugin to list all active connections and scanning ports on a target address (replacement of both nu_plugin_port_scan and nu_plugin_port_list since 0.102";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_port_extension";
  };
})
