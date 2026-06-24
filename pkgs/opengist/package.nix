{
  lib,
  stdenv,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  moreutils,
  jq,
  git,
  writableTmpDirAsHomeHook,
}:

# TODO: Remove once nixpkgs updates opengist
buildGoModule (finalAttrs: {
  pname = "opengist";
  version = "unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "thomiceli";
    repo = "opengist";
    rev = "cac21689cf1a523d4b67b78feb02996d589667bc";
    hash = "sha256-RyhSYy0cjRDJrSGZcKUsr5qzEBVknDRAQXXwIUGdYcc=";
  };

  frontend = buildNpmPackage {
    pname = "opengist-frontend";
    inherit (finalAttrs) version src;

    # npm complains of "invalid package". shrug. we can give it a version.
    postPatch = ''
      ${lib.getExe jq} '.version = "${finalAttrs.version}"' package.json | ${lib.getExe' moreutils "sponge"} package.json
    '';

    installPhase = ''
      mkdir -p $out
      cp -R public $out
    '';

    npmDepsHash = "sha256-Ci25S0kgT5C46xTzNTs0kn8QEvYqJuj/yU33Ymfci68=";
  };

  patches = [ ./downgrade-go.patch ];

  vendorHash = "sha256-gYtbQGXX1Dg4DQafEiVqqlWgsFk/WchSc8eMW9/c7r4=";

  tags = [ "fs_embed" ];

  ldflags = [
    "-s"
    "-X github.com/thomiceli/opengist/internal/config.OpengistVersion=v${finalAttrs.version}"
  ];

  nativeCheckInputs = [
    git
    writableTmpDirAsHomeHook
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkPhase = ''
    runHook preCheck

    make test

    runHook postCheck
  '';

  postPatch = ''
    mkdir -p public/.vite
    cp ${finalAttrs.frontend}/public/.vite/manifest.json public/.vite/manifest.json
    cp -R ${finalAttrs.frontend}/public/assets public/
  '';

  passthru = { inherit (finalAttrs) frontend; };

  meta = {
    description = "Self-hosted pastebin powered by Git";
    homepage = "https://github.com/thomiceli/opengist";
    license = lib.licenses.agpl3Only;
    changelog = "https://github.com/thomiceli/opengist/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "opengist";
  };
})
