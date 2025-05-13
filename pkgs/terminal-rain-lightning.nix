{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "terminal-rain-lightning";
  version = "unstable-2025-05-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rmaake1";
    repo = "terminal-rain-lightning";
    rev = "b7199c634d6d38cfd546700b63acd6e746fc565c";
    hash = "sha256-IwXgxiofTvYUT/r5lG2BZrA/jKcHq+euonc+aCVCnF4=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "terminal_rain_lightning" ];

  meta = {
    description = "Terminal-based ASCII rain and lightning animation";
    homepage = "https://github.com/rmaake1/terminal-rain-lightning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "terminal-rain";
  };
}
