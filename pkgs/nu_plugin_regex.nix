{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_regex";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_regex";
    rev = "v${version}";
    hash = "sha256-DclqER98jdX7sthIkUhMT4qxUxn6LFQmDT13qtMnmLg=";
  };

  cargoHash = "sha256-9yo0rgZ8MBPGu0grgCL6hsKXYWxB9SEi8vVCRwMEKac=";

  meta = {
    description = "Nushell plugin to search text with regular expressions";
    homepage = "https://github.com/fdncred/nu_plugin_regex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
