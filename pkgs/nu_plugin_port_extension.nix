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
    hash = "sha256-6fo7g1YqtJE4mqMmz6ivf/l6y+sXIgbpducaJ+Z3Hek=";
  };

  cargoHash = "sha256-w3iEe7rm0z+eRTjlsaWcUVpqst9Kzy1JlQ89DnUc2iA=";

  meta = {
    description = "A nushell plugin to list all active connections and scanning ports on a target address (replacement of both nu_plugin_port_scan and nu_plugin_port_list since 0.102";
    homepage = "https://github.com/fmotalleb/nu_plugin_port_extension";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_port_extension";
  };
})
