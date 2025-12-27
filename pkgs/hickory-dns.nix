{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "0.26.0-alpha.1";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tXBGnrD0KrIhRKBEeq+jLSgFWHFTRUU6AGiAGEALIwk=";
  };

  cargoHash = "sha256-p3IDm+C8266Lh2To0Vho0SNL91VRktMljpI89J/A0u4=";

  buildFeatures = [
    "tls-ring" # DoT
    "https-ring" # DoH
    "quic-ring" # QUIC
    "h3-ring" # DoH3
    "dnssec-ring" # DNSSEC

    "blocklist" # allow/deny blocklists
    "recursor" # experimental recursive dns
    "text-parsing"
  ];

  buildInputs = [ sqlite ];

  doCheck = false; # Tests depend on internet connection

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "A Rust based DNS client, server, and resolver";
    homepage = "https://github.com/hickory-dns/hickory-dns";
    changelog = "https://github.com/hickory-dns/hickory-dns/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "hickory-dns";
  };
})
