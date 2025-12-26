{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
}:

buildGoModule rec {
  pname = "dumb";
  version = "unstable-2025-07-06";

  src = fetchFromGitHub {
    owner = "rramiachraf";
    repo = "dumb";
    rev = "132af50dd6ac4994dd9f4f7dffa144be74f9c0f1";
    hash = "sha256-rrIyAVt9TuNedt7BkZZbJx/JoMLeG9agKP63pCxTsKA=";
  };

  nativeBuildInputs = [ esbuild ];

  vendorHash = "sha256-A9QjEYdjwcB690PVpm0NS5vjxpl12gKtrwIMZbS7ym0=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-X"
    "github.com/rramiachraf/dumb/data.Version=${lib.sources.shortRev src.rev}"
    "-s"
    "-w"
  ];

  # NOTE: nixpkgs templ is too new. Check fails.
  preBuild = ''
    go tool templ generate
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
}
