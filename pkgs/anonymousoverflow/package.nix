{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (_: {
  pname = "anonymousoverflow";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "httpjamesm";
    repo = "AnonymousOverflow";
    rev = "4b53d30dffa9d73fdc05b0201234cc9cb9926c23";
    hash = "sha256-pYt4Fkh/t86AIJeFEx0P8U/GumWMXnknOn2wkXR6mf4=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";

  env.CGO_ENABLED = 0;

  patches = [ ./embed-files.patch ];

  ldflags = [ "-s" ];

  meta = {
    description = "View StackOverflow in privacy and without the clutter";
    homepage = "https://github.com/httpjamesm/AnonymousOverflow";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "anonymousoverflow";
  };
})
