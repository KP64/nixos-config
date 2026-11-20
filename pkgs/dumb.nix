{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
  templ,
}:
buildGoModule (finalAttrs: {
  pname = "dumb";
  version = "unstable-2026-10-22";

  src = fetchFromGitHub {
    owner = "rramiachraf";
    repo = "dumb";
    rev = "1e8905c10741eec48742bacdbdda8040e585d8de";
    hash = "sha256-pQuXC9l99VJqAbj/wO98X7UvFdYflzWcmV+x6vytf9s=";
  };

  __structuredAttrs = true;

  checkFlags =
    let
      # Tests rely on internet to connect to genius.
      skippedTests = [
        "TestAlbum"
        "TestAnnotations"
        "TestArticle"
        "TestArtist"
        "TestInstancesList"
        "TestLyrics"
        "TestImageProxy"
        "TestSearch"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-hAP1M8YBbAMgABKqJo+zlcanknth31KUBxbu4jg3IeE=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X"
    "github.com/rramiachraf/dumb/data.Version=${lib.sources.shortRev finalAttrs.src.rev}"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [
    esbuild
    templ
  ];

  preBuild = ''
    templ generate
    cat $src/style/*.css | esbuild --loader=css --minify > ./static/style.css
  '';

  meta = {
    description = "Private alternative front-end for Genius";
    homepage = "https://github.com/rramiachraf/dumb";
    license = lib.licenses.mit;
    mainProgram = "dumb";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ KP64 ];
  };
})
