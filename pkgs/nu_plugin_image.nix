{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_image";
  version = "0.109.1";

  src = fetchFromGitHub {
    owner = "fmotalleb";
    repo = "nu_plugin_image";
    rev = "v${version}";
    hash = "sha256-buTy84i/8wK+Lj14sqsUaP0Vj+qU1qWGa1P5WyKXZPc=";
  };

  cargoHash = "sha256-nG4HgJJezz+W0CPr29LfJgzSUUcxPfYNAqogjpYMGjw=";
  meta = {
    description = "A Nushell plugin to convert ANSI strings into PNG images and create ANSI text from images";
    homepage = "https://github.com/fmotalleb/nu_plugin_image";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_image";
  };
}
