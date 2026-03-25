{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (_: {
  pname = "nufmt";
  version = "0-unstable-2026-03-25";

  src = fetchFromGitHub {
    owner = "nushell";
    repo = "nufmt";
    rev = "5d87e5f29b128d52b7644474671bb4ddae617ad0";
    hash = "sha256-iD4bgqC8yApIQv7Wpl66KHC7gkSd8oyrHonChEhnAtc=";
  };

  doCheck = false;
  cargoHash = "sha256-heHFiW1/2qV6BJH7Y0ObSV1sPfVaU0m2KLbASdzca8s=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  meta = {
    description = "";
    homepage = "https://github.com/nushell/nufmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nufmt";
  };
})
