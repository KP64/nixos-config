{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "anonymousoverflow";
  version = "1.14.1";

  src = fetchFromGitHub {
    owner = "httpjamesm";
    repo = "AnonymousOverflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QhxvIgFGFLfLg4Oh+FjfzNajBYTmabDw0GMdVFvUMsw=";
  };

  __structuredAttrs = true;

  vendorHash = "sha256-P3kUGFJhj/pTNeVTwtg4IqhoHBH9rROfkr+ZsrUtmdo=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "View StackOverflow in privacy and without the clutter";
    homepage = "https://github.com/httpjamesm/AnonymousOverflow";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "anonymousoverflow";
  };
})
