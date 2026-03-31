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
    rev = "188d5f7e41e5fdafab88f30e1b2c3e558399b53d";
    hash = "sha256-g+MBVqdPtG8ugBfYxjIrJgGcDnikzHgHnjcCYC5vx2Y=";
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
