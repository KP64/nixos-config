{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_emoji";
  version = "unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_emoji";
    rev = "bbbc08719ebb2563c110bfdd41fc0fbcfb1d6bb9";
    hash = "sha256-3O/uVWcByC44qtfoWEs/+NWWefcQKvqYyiEbgSG8EnQ=";
  };

  cargoHash = "sha256-sb9+kONbBle4LvtRSxCmogzmsaZsYAbHRsjL5RqrSg4=";

  meta = {
    description = "A nushell plugin that makes finding and printing emojis easy in nushell";
    homepage = "https://github.com/fdncred/nu_plugin_emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = pname;
  };
}
