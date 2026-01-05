{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "nu_plugin_hcl";
  version = "0.109.1";

  src = fetchFromGitHub {
    owner = "Yethal";
    repo = "nu_plugin_hcl";
    rev = version;
    hash = "sha256-EDWvmAtz2cJmZpnSZqLyty/D9dYFj963qhMl5Svvn7w=";
  };

  cargoHash = "sha256-gMZIN7rNW3do5KBzVY2ntMSq4CdImKs7nPxl/msVjSE=";

  meta = {
    description = "A Hashicorp Configuration Language plugin for nushell";
    homepage = "https://github.com/Yethal/nu_plugin_hcl/tree/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_hcl";
  };
}
