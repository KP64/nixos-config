{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_regex";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_regex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-DAvkem1H9sozj5FIW6yc5++ch6gFlPScz6T0eyCHWLY=";
  };

  cargoHash = "sha256-9Qet8nROOYxnD4NHp0BGeYedKu4zQYj9EK9lMI4kLlM=";

  meta = {
    description = "Nushell plugin to search text with regular expressions";
    homepage = "https://github.com/fdncred/nu_plugin_regex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_regex";
  };
})
