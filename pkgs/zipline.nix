{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_25,
  makeWrapper,
  prisma-engines_6,
  ffmpeg,
  openssl,
  vips,
  node-gyp,
  pkg-config,
  python3,
}:

# TODO: Remove once new release is in nixpkgs
let
  environment = {
    NEXT_TELEMETRY_DISABLED = "1";
    FFMPEG_PATH = lib.getExe ffmpeg;
    FFPROBE_PATH = lib.getExe' ffmpeg "ffprobe";
    PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_6 "schema-engine";
    PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_6 "query-engine";
    PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines_6}/lib/libquery_engine.node";
    PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines_6 "introspection-engine";
    PRISMA_FMT_BINARY = lib.getExe' prisma-engines_6 "prisma-fmt";
  };

  pnpm' = pnpm_10.override { nodejs = nodejs_25; };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "zipline";
  version = "0-unstable-2026-04-14";

  src = fetchFromGitHub {
    owner = "diced";
    repo = "zipline";
    rev = "aa43f66570ea7f6881bb002a5f79ce34db901631";
    hash = "sha256-Efb0qSLlASq5/SMOISFIS5jOKgdX80k44ttnhsMpl48=";
    leaveDotGit = true;
    postFetch = ''
      git -C $out rev-parse --short HEAD > $out/.git_head
      rm -rf $out/.git
    '';
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm';
    fetcherVersion = 3;
    hash = "sha256-rCj+JVGKR2P+OmDzqSwjC8E9638WX5YhpohNBv3+7qw=";
  };

  buildInputs = [
    openssl
    vips
  ];

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm'
    nodejs_25
    makeWrapper
    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  env = environment // {
    DATABASE_URL = "dummy";
    NODE_PATH = "${node-gyp}/lib/node_modules";
  };

  buildPhase = ''
    runHook preBuild

    # Force build of sharp against native libvips (requires running install scripts).
    # This is necessary for supporting old CPUs (ie. without SSE 4.2 instruction set).
    pnpm config set nodedir ${nodejs_25}
    pnpm install --force --offline --frozen-lockfile

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    CI=true pnpm prune --prod
    find node_modules -xtype l -delete

    mkdir -p $out/{bin,share/zipline}

    cp -r build node_modules prisma mimes.json code.json package.json $out/share/zipline

    mkBin() {
      makeWrapper ${lib.getExe nodejs_25} "$out/bin/$1" \
        --chdir "$out/share/zipline" \
        --set NODE_ENV production \
        --set ZIPLINE_GIT_SHA "$(<$src/.git_head)" \
        --prefix PATH : ${lib.makeBinPath [ openssl ]} \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
        ${
          lib.concatStringsSep " " (
            lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") environment
          )
        } \
        --add-flags "--enable-source-maps build/$2"
    }

    mkBin zipline server
    mkBin ziplinectl ctl

    runHook postInstall
  '';

  passthru.prisma-engines = prisma-engines_6;

  meta = {
    description = "ShareX/file upload server that is easy to use, packed with features, and with an easy setup";
    homepage = "https://zipline.diced.sh/";
    downloadPage = "https://github.com/diced/zipline";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "zipline";
    platforms = lib.platforms.linux;
  };
})
