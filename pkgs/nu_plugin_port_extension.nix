{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_port_extension";
  version = "0.111.0";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_port_extension";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E1fTey46MOh8ouXy1PhjraeUdfwZaLYl/BdT+Vboq+Y=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-qaqHcJ+MXMq5nj94Tf0CdOXVl3d6U3R68Stqy0oFNpY=";

  meta = {
    description = "A nushell plugin to list all active connections and scanning ports on a target address (replacement of both nu_plugin_port_scan and nu_plugin_port_list since 0.102";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_port_extension";
  };
})
