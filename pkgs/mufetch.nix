{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mufetch";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ashish0kumar";
    repo = "mufetch";
    rev = "v${version}";
    hash = "sha256-HeXzJU66CyG1DfhlYJ6G295oBlEKPPDuxctyUHZaEF0=";
  };

  vendorHash = "sha256-aXSNM6z/U+2t0aGtr5MIjTb7huAQY/yRf6Oc1udLJYI=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/ashish0kumar/mufetch/cmd.version=${version}"
  ];

  meta = {
    description = "Neofetch-style CLI for music";
    homepage = "https://github.com/ashish0kumar/mufetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "mufetch";
  };
}
