{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gitMinimal,
  cmakeMinimal,
}:

# TODO: Remove once nixpkgs updates redlib https://github.com/NixOS/nixpkgs/pull/520226
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "redlib";
  version = "0.40.0";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qv7vIls9BwgwDQuKEQU72J10MpaMfcLvIGfzl628eNU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-XgHXqH4EF8TEOI+cKJ0Z2j6QYRCwGgv8bmY8gZpPN9c=";

  doCheck = false;

  nativeBuildInputs = [
    gitMinimal
    cmakeMinimal
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "Private front-end for Reddit";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "redlib";
  };
})
