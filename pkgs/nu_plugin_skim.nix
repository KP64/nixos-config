{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_skim";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "idanarye";
    repo = "nu_plugin_skim";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cFk+B2bsXTjt6tQ/IVVefkOTZKjvU1hiirN+UC6xxgI=";
  };

  cargoHash = "sha256-eNT4NfSlyKuVUlOrmSNoimJJ1zU88prSemplbBWcyag=";

  meta = {
    description = "This is a Nushell plugin that adds integrates the skim fuzzy finder";
    homepage = "https://github.com/idanarye/nu_plugin_skim/commits/main/";
    changelog = "https://github.com/idanarye/nu_plugin_skim/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_skim";
  };
})
