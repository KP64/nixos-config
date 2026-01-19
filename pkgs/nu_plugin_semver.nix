{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_semver";
  version = "0.11.9";

  src = fetchFromGitHub {
    owner = "abusch";
    repo = "nu_plugin_semver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RdVN2KqEf/5Ir8n6+CUXYZMBb2GFenYNKcudq9Abg9g=";
  };

  cargoHash = "sha256-/SB1jCZFM56v0bnxwOqds6N3jGuIpM7RtZaqiSk1xdE=";

  meta = {
    description = "A nushell plugin to work with semver versions";
    homepage = "https://github.com/abusch/nu_plugin_semver";
    changelog = "https://github.com/abusch/nu_plugin_semver/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_semver";
  };
})
