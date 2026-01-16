{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "unstable-2026-01-15";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "47e67972514e2c3d1657338ce592cb3692607e90";
    hash = "sha256-q4wu3NUwDJzUsYDYlG0WT7fAOCltVVP2AAsCabpys5w=";
  };

  cargoHash = "sha256-TDNcQS78tbalNfHx5wC2v1PxEdxrC4eFdJSTetk1CsI=";

  buildFeatures = [
    "tls-ring" # DoT
    "https-ring" # DoH
    "quic-ring" # QUIC
    "h3-ring" # DoH3
    "dnssec-ring" # DNSSEC

    "blocklist" # allow/deny blocklists
    "recursor" # experimental recursive dns
    "toml"
    "tokio"
    "serde"
    "mdns"
    "text-parsing"

    "system-config"
    "rustls-platform-verifier"
    "resolver"

    # "metrics"
    # "prometheus-metrics"
  ];

  buildInputs = [ sqlite ];

  doCheck = false; # Tests depend on internet connection

  meta = {
    description = "A Rust based DNS client, server, and resolver";
    homepage = "https://github.com/hickory-dns/hickory-dns";
    changelog = "https://github.com/hickory-dns/hickory-dns/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "hickory-dns";
  };
})
