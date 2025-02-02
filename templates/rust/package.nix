{
  lib,
  rustPlatform,
  stdenv,
  darwin,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "";
  version = "";

  src = ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ (lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ]);

  useNextest = true;
  # Remove this line when application has >= 1 tests.
  doCheck = false;

  meta = {
    description = "";
    homepage = "";
    # Hopefully you unlicense everything
    # for the greater good of OSS ;)
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ ];
    mainProgram = pname;
  };
}
