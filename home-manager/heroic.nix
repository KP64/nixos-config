{ pkgs, ... }:
let
  catppuccin_repo = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "heroic";
    rev = "8f32fd139320a8d85d9d5176090538cbf05f3c0f";
    sha256 = "sha256-JpQtZAxx+GdB3oVk1uFTidO3sykhQxea9nDFcCrcyQI=";
  };
in
{
  home.packages = with pkgs; [ heroic ];

  xdg.configFile."heroic/themes" = {
    source = catppuccin_repo + "/themes/";
    recursive = true;
  };
}
