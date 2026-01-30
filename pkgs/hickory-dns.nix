{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "db923c347b22ed8e4ddec0e88ccb5f14a4b1b1a2";
    hash = "sha256-Y/IRoLtFPQYUvx+o2qix1xwoX4FR6sdeJESkcXCbd5c=";
  };

  cargoHash = "sha256-WPrikiBllkZb+pUNWgKLPBsDCRbh0caBqSVan3RAz8g=";

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
