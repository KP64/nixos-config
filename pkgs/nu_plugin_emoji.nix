{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nu_plugin_emoji";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "fdncred";
    repo = "nu_plugin_emoji";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tmkSKPVjDTlJYs2v0sQo17TTDRsTTwiPmc9w4ogB8xk=";
  };

  cargoHash = "sha256-eUjw97kNKJCwI7bfCJuX3NggK2TxdK/0PJtKS5GSBnY=";

  meta = {
    description = "A nushell plugin that makes finding and printing emojis easy in nushell";
    homepage = "https://github.com/fdncred/nu_plugin_emoji";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "nu_plugin_emoji";
  };
})
