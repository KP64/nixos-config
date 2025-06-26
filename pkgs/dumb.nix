{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
}:

buildGoModule rec {
  pname = "dumb";
  version = "unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "rramiachraf";
    repo = pname;
    rev = "f5df91fffe50283295f82488e4ec63a4be23f04e";
    hash = "sha256-5HV14vMmUfwe132g1BBD3ZQctEcNeTZkbYfnvSEE8CM=";
  };

  nativeBuildInputs = [ esbuild ];

  vendorHash = "sha256-A9QjEYdjwcB690PVpm0NS5vjxpl12gKtrwIMZbS7ym0=";

  ldflags =
    let
      shortRev = builtins.substring 0 8 src.rev;
    in
    [
      "-X"
      "'github.com/rramiachraf/dumb/data.Version=${shortRev}'"
      "-s"
      "-w"
    ];

  preBuild = ''
    go tool templ generate
    cat $src/style/*.css | esbuild --loader=css --minify > ./static/style.css
  '';

  # Tests would never pass because they rely on
  # an internet connection.
  doCheck = false;

  meta = {
    description = "Private alternative front-end for Genius";
    homepage = "https://github.com/rramiachraf/dumb";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
