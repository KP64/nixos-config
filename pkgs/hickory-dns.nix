{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "unstable-2026-03-20";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "32a162faa247b6873ab86e6b1605f28154aa5e7a";
    hash = "sha256-t0AL1iU4DIpIpjEJj2Qz3z7lnyYflJiPn8RAoZhusJ0=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-f1pB0FjQ7AUbOHAjdrav5No48Gda+KymEI8DERTxtQ8=";

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

    "metrics"
    "prometheus-metrics"
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
