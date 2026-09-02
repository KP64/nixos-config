{ inputs, ... }: {
  flake-file.inputs.harmonia = {
    type = "github";
    owner = "nix-community";
    repo = "harmonia";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      treefmt-nix.follows = "";
    };
  };

  den.aspects.mahdi.nixos =
    { config, lib, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
    in
    {
      imports = [ inputs.harmonia.nixosModules.harmonia ];

      config = lib.mkMerge [
        (lib.mkIf config.services.harmonia-dev.cache.enable {
          sops.secrets.harmonia-key.restartUnits = [ config.systemd.services.harmonia-dev.name ];

          services.caddy.virtualHosts."cache.${config.networking.domain}".extraConfig = # caddy
            ''
              reverse_proxy unix/${lib.removePrefix "unix:" config.services.harmonia-dev.cache.settings.bind}
              header {
                  Strict-Transport-Security "max-age=31536000; includeSubDomains"
                  Content-Security-Policy "${
                    mkCSP {
                      default-src = "none";
                      img-src = "self";
                      style-src = "sha256-vH51d+jQVG4ixznlvoAz0qhElwpeG9xvknvU+YT7Tn8=";
                    }
                  }"
                  X-Frame-Options SAMEORIGIN
                  X-Content-Type-Options nosniff
                  Referrer-Policy no-referrer
                  Permissions-Policy "${
                    mkPP {
                      camera = "()";
                      microphone = "()";
                      geolocation = "()";
                      usb = "()";
                      bluetooth = "()";
                      payment = "()";
                      accelerometer = "()";
                      gyroscope = "()";
                      magnetometer = "()";
                      midi = "()";
                      serial = "()";
                      hid = "()";
                    }
                  }"
                  Cross-Origin-Embedder-Policy require-corp
                  Cross-Origin-Opener-Policy same-origin
                  Cross-Origin-Resource-Policy same-origin
              }
            '';
        })
        {
          services.harmonia-dev = {
            daemon.enable = true;
            cache = {
              enable = true;
              signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
              settings.bind = "unix:/run/harmonia/harmonia.socket";
            };
          };
        }
      ];
    };
}
