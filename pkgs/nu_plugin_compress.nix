{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_compress";
  version = "unstable-2025-10-25";

  src = fetchFromGitHub {
    owner = "yybit";
    repo = "nu_plugin_compress";
    rev = "5bc5d0e851f88f4a22318d0fafa11c2ba814f310";
    hash = "sha256-936lpBuvOtwzAHUmum0A4UIjGtGoQ/f3gHHUxFAnZ3Y=";
  };

  cargoHash = "sha256-RhTkYCuelvxYQsyOQvAzE0bFm1S2uvPpmLb0kMCpD7k=";

  meta = {
    description = "A nushell plugin for compression and decompression, supporting zstd, gzip, bzip2, and xz";
    homepage = "https://github.com/yybit/nu_plugin_compress";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
