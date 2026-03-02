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
    rev = "6aaeb47366bbb4181ce3b2cd7aae39bfcc1c9ca3";
    hash = "sha256-cSDhqJ+nXg97faNZJ+R+z49QU5eD56QGx1NY+ngn6ro=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-ikyUyadmRxHx/KhuZzWiZgmY2BTyuNGZ/C+keyLpsfE=";

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
