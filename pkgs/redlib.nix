{
  lib,
  rustPlatform,
  fetchFromGitHub,
  perl,
}:

# TODO: Remove this once redlib fixes their annoying issues
rustPlatform.buildRustPackage (_: {
  pname = "redlib";
  version = "0-unstable-2025-12-04";

  src = fetchFromGitHub {
    owner = "chowder";
    repo = "redlib";
    rev = "42fe41bc4c64690aa91cd1cfecec3bad3438354f";
    hash = "sha256-iYH5WeQLitDA6unTJoR0+DYQWmTSQd0WRFfwRYvkVHI=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-/oSZR/VMYyDTA9b48EXll/FC7UwN0xhA9BtQVwrBoMk=";

  doCheck = false;
  nativeBuildInputs = [ perl ];

  meta = {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "redlib";
  };
})
