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
    rev = "937cfeefd6dcbab92ef572671f16d4d3be6abad3";
    hash = "sha256-QhxvIgFGFLfLg4Oh+FjfzNajBYTmabDw0GMdVFvUMsw=";
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
