{
  inputs,
  lib,
  buildGoModule,
  esbuild,
}:

buildGoModule rec {
  pname = "dumb";
  version = "unstable-2025-07-06";

  src = inputs.pkg_dumb;

  nativeBuildInputs = [ esbuild ];

  vendorHash = "sha256-A9QjEYdjwcB690PVpm0NS5vjxpl12gKtrwIMZbS7ym0=";

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
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "dumb";
  };
}
