{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_dns";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "dead10ck";
    repo = "nu_plugin_dns";
    rev = "v${version}";
    hash = "sha256-YMkefyXfM+l/6Fk1eGry/fxIahLQW6jQA6nQcQwQwtc=";
  };

  cargoHash = "sha256-p2RepMX/zk8ALT+gC8iu/S3tnHY43Pfql6/dBw1c0Oc=";

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
