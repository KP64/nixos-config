{
  lib,
  buildGoModule,
  fetchFromGitHub,
  esbuild,
  stdenvNoCC,
}:
let
  # nixpkgs templ is too new. Check fails.
  # import newest yet compatible nixpkgs.
  oldNixpkgs = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "a19cd4ffb1f4b953a76f3ac29c6520d0b1877108";
    hash = "sha256-ytHMMsgrwPIZz2xoQKKktb1p3EiUhkTTH1NxbtxaIMI=";
  };
  oldPkgs = import oldNixpkgs { inherit (stdenvNoCC.hostPlatform) system; };
in
buildGoModule (finalAttrs: {
  pname = "dumb";
  version = "unstable-2026-03-14";

  src = fetchFromGitHub {
    owner = "rramiachraf";
    repo = "dumb";
    rev = "ad6571d242a8a22adf5259a97c6afb711dfc0717";
    hash = "sha256-MSjk/gpLtdlOVL7h7hcjlcAyUGhu1ZpguT1ZZwHfHNs=";
  };

  __structuredAttrs = true;

  nativeBuildInputs = [
    esbuild
    oldPkgs.templ
  ];

  vendorHash = "sha256-A9QjEYdjwcB690PVpm0NS5vjxpl12gKtrwIMZbS7ym0=";

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
