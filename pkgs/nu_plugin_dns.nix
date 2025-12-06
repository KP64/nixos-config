{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_dns";
  version = "unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    rev = "d821970df095338606eee18517d50dd143b913bf";
    hash = "sha256-DBpPQwLVU/WQGOWLkE+ybzXnMTXkxaHLcUQJAElgV0A=";
  };

  cargoHash = "sha256-IhAKn8U6Cr7jxHWU06hBsXP0hTDnFVJlJsZVQ8cM27k=";

  doCheck = false;

  meta = {
    description = "DNS utility for nushell";
    homepage = "https://github.com/dead10ck/nu_plugin_dns";
    changelog = "https://github.com/dead10ck/nu_plugin_dns/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
