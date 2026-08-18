{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (_: {
  pname = "anonymousoverflow";
  version = "0-unstable-2026-08-10";

  src = fetchFromGitHub {
    owner = "httpjamesm";
    repo = "AnonymousOverflow";
    rev = "cbd3f66a5b6fe050428124deab9496bd1b930295";
    hash = "sha256-dEoMf2RDvgF0U4lafkkecZh2aGcRs3XYroOervRXL5A=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";

  env.CGO_ENABLED = 0;

  ldflags = [ "-s" ];

  meta = {
    description = "View StackOverflow in privacy and without the clutter";
    homepage = "https://github.com/httpjamesm/AnonymousOverflow";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "anonymousoverflow";
  };
})
