{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_desktop_notifications";
  version = "0.109.1";

  src = fetchFromGitHub {
    owner = "FMotalleb";
    repo = "nu_plugin_desktop_notifications";
    rev = "v${version}";
    hash = "sha256-eNdaaOgQWd5qZQG9kypzpMsHiKX7J5BXPSsNLJYCVTo=";
  };

  cargoHash = "sha256-Mo+v3725jVNTCy7qjvTnDDN2JSAI48tpPCoQoewo4wM=";

  meta = {
    description = "A nushell plugin to send notification to desktop using notify-rust";
    homepage = "https://github.com/FMotalleb/nu_plugin_desktop_notifications";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_desktop_notifications";
  };
}
