{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
}:

# Custom package needed to fix rich-preview.yazi
# TODO: Use nixpkgs version once 1.8.1 lands there
python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "rich-cli";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "rich-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z1Ea8f8QNgy2CWGyQWgY2Y/tpg269R5n9Qrs1YhCHa8=";
  };

  build-system = [ python3.pkgs.poetry-core ];

  pythonImportsCheck = [ "rich_cli" ];

  pythonRelaxDeps = [
    "rich"
    "textual"
  ];

  dependencies = with python3Packages; [
    click
    requests
    rich
    rich-rst
    textual
  ];

  meta = {
    description = "Rich-cli is a command line toolbox for fancy output in the terminal";
    homepage = "https://github.com/Textualize/rich-cli";
    changelog = "https://github.com/Textualize/rich-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ KP64 ];
    mainProgram = "rich-cli";
  };
})
