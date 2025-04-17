{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "wrkflw";
  version = "unstable-2025-04-14";

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "wrkflw";
    rev = "fb65b6765439f1048d37f935d8527d419377a621";
    hash = "sha256-NWtpHeRl4Jojm+yH5iWr7uHUlNVfRgIi0uQ1zthkmCQ=";
  };

  cargoHash = "sha256-zRaDFBolYRiMlaYeGFha8JkUXF+0/8dccEWToAvnCtg=";

  useFetchCargoVendor = true;
  useNextest = true;

  meta = {
    description = "Validate and execute GitHub Actions workflows locally";
    homepage = "https://github.com/bahdotsh/wrkflw";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
