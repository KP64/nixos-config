{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
  templ,
}:
buildGoModule (finalAttrs: {
  pname = "dumb";
  version = "unstable-2026-09-26";

  src = fetchFromGitHub {
    owner = "rramiachraf";
    repo = "dumb";
    rev = "f5581074850bc31ed7df1ce96e8f428179bf0abb";
    hash = "sha256-ajyMDzRlvAmQujcUEEQs7yffWVKrvgDZgLimTCT6eZI=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    esbuild
    templ
  ];

  vendorHash = "sha256-FobXK38l1dxCd0qDBynWhQtHVdx9rMtWRS94Jg99jQ4=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X"
    "github.com/rramiachraf/dumb/data.Version=${lib.sources.shortRev finalAttrs.src.rev}"
    "-s"
    "-w"
  ];

  preBuild = ''
    templ generate
    cat $src/style/*.css | esbuild --loader=css --minify > ./static/style.css
  '';

  # Checks rely on internet.
  doCheck = false;

  meta = {
    description = "Private alternative front-end for Genius";
    homepage = "https://github.com/rramiachraf/dumb";
    license = lib.licenses.mit;
    mainProgram = "dumb";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ KP64 ];
  };
})
