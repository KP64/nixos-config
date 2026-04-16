{
  lib,
  rustPlatform,
  fetchFromGitHub,
  sqlite,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hickory-dns";
  version = "unstable-2026-04-16";

  src = fetchFromGitHub {
    owner = "hickory-dns";
    repo = "hickory-dns";
    rev = "6317c5a1050505e2ec377acfd5dd4fd40450e6e6";
    hash = "sha256-1VryKiE7kri7XQmVpCmZjc98L9iN60UVz5bNgphjDAU=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-El5NuGevzTpHJP5MVYjyED0UwV7xM9iwv/X7x5Gz/+I=";

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

    "system-config"
    "systemd"
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
