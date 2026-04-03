{
  # NOTE: Nginx conf taken and modified from https://github.com/alam00000/bentopdf/blob/main/nginx.conf
  flake.modules.nixos.hosts-mahdi =
    { config, ... }:
    let
      inherit (config.lib.securityHeader) mkCSP mkPP;
      commonHeaders = # nginx
        ''
          add_header Cross-Origin-Resource-Policy "cross-origin" always;
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Referrer-Policy no-referrer always;
          add_header Content-Security-Policy "${
            mkCSP {
              default-src = "none";
              script-src = [
                "self"
                "unsafe-inline"
              ];
              style-src = [
                "self"
                "unsafe-inline"
              ];
              connect-src = "self";
              font-src = [
                "self"
                "data:"
              ];
              img-src = [
                "self"
                "data:"
              ];
            }
          }" always;
          add_header Permissions-Policy "${
            mkPP {
              camera = "()";
              microphone = "()";
              geolocation = "()";
              usb = "()";
              bluetooth = "()";
              payment = "()";
              accelerometer = "()";
              magnetometer = "()";
              midi = "()";
              serial = "()";
              hid = "()";
            }
          }" always;
        '';
    in
    {
      services.bentopdf = {
        enable = true;
        domain = "bentopdf.${config.networking.domain}";
        nginx = {
          enable = true;
          virtualHost = {
            enableACME = true;
            acmeRoot = null;
            onlySSL = true;
            kTLS = true;
            locations = {
              "~ ^/(en|ar|be|da|de|es|fr|id|it|ko|nl|pt|ru|sv|tr|vi|zh|zh-TW)(/.*)?$".extraConfig = # nginx
                ''
                  try_files $uri $uri/ $uri.html /$1/index.html /index.html;
                  expires 5m;
                  add_header Cache-Control "public, must-revalidate";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~ ^/(.+?)/(en|ar|be|da|de|es|fr|id|it|ko|nl|pt|ru|sv|tr|vi|zh|zh-TW)(/.*)?$".extraConfig = # nginx
                ''
                  try_files $uri $uri/ $uri.html /$1/$2/index.html /$1/index.html /index.html;
                  expires 5m;
                  add_header Cache-Control "public, must-revalidate";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* \.html$".extraConfig = # nginx
                ''
                  expires 1h;
                  add_header Cache-Control "public, must-revalidate";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* /libreoffice-wasm/soffice\.wasm\.gz$".extraConfig = # nginx
                ''
                  gzip off;
                  types {} default_type application/wasm;
                  add_header Content-Encoding gzip;
                  add_header Vary "Accept-Encoding";
                  add_header Cache-Control "public, immutable";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* /libreoffice-wasm/soffice\.data\.gz$".extraConfig = # nginx
                ''
                  gzip off;
                  types {} default_type application/octet-stream;
                  add_header Content-Encoding gzip;
                  add_header Vary "Accept-Encoding";
                  add_header Cache-Control "public, immutable";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* \.(wasm|wasm\.gz|data|data\.gz)$".extraConfig = # nginx
                ''
                  expires 1y;
                  add_header Cache-Control "public, immutable";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* \.(js|mjs|css|woff|woff2|ttf|eot|otf)$".extraConfig = # nginx
                ''
                  expires 1y;
                  add_header Cache-Control "public, immutable";
                  add_header Cross-Origin-Embedder-Policy "require-corp" always;
                  add_header Cross-Origin-Opener-Policy "same-origin" always;
                  ${commonHeaders}
                '';
              "~* \.(png|jpg|jpeg|gif|ico|svg|webp|avif|mp4|webm)$".extraConfig = # nginx
                ''
                  expires 1y;
                  add_header Cache-Control "public, immutable";
                  ${commonHeaders}
                '';
              "~* \.json$".extraConfig = # nginx
                ''
                  expires 1w;
                  add_header Cache-Control "public, must-revalidate";
                  ${commonHeaders}
                '';
              "~* \.pdf$".extraConfig = # nginx
                ''
                  expires 1y;
                  add_header Cache-Control "public, immutable";
                  ${commonHeaders}
                '';
              "/" = {
                index = "index.html";
                extraConfig = # nginx
                  ''
                    expires 5m;
                    add_header Cache-Control "public, must-revalidate";
                    add_header Cross-Origin-Embedder-Policy "require-corp" always;
                    add_header Cross-Origin-Opener-Policy "same-origin" always;
                    ${commonHeaders}
                  '';
              };
            };
          };
        };
      };
    };
}
