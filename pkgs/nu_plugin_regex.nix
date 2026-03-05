{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_regex";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_regex";
    rev = "v${finalAttrs.version}";
    hash = "sha256-E0CnjckAY176cdn8ZwlzM/opGieGqr7iA5NhEJnlOWc=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-u5bdrITNJanj+5DG+FmnKClivQ2qrZ2JtdHlw70UmXY=";

  meta = {
    description = "Nushell plugin to search text with regular expressions";
    homepage = "https://github.com/fdncred/nu_plugin_regex";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_regex";
  };
})
