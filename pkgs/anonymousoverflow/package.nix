{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (_: {
  pname = "anonymousoverflow";
  version = "0-unstable-2025-12-03";

  src = fetchFromGitHub {
    owner = "httpjamesm";
    repo = "AnonymousOverflow";
    rev = "08f83c6430bffa11669618553efb499b97566436";
    hash = "sha256-YmjAfO2v81rzJxm7q5C8WZLRoGXQpxHdErpjte8rFnI=";
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
