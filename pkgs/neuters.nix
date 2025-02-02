{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  git,
}:

rustPlatform.buildRustPackage rec {
  pname = "neuters";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "HookedBehemoth";
    repo = "neuters";
    rev = version;
    hash = "sha256-JyOsWGj8SC8CH6+02EFPIEY1NTb78zYyhdyddbCKlRc=";
  };

  cargoHash = "sha256-kVvLU0bQtuSPPD5uijQaV4B+oiEpfoPYHsyPu4qlV8w=";

  nativeBuildInputs = [ git ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = {
    description = "Reuters Redirect and Proxy";
    homepage = "https://github.com/HookedBehemoth/neuters";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "neuters";
  };
}
