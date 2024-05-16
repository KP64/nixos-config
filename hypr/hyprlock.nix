{ inputs, pkgs, ... }:

# Catppuccin doesn't support catppuccin option for hyprlock yet.
# TODO: Replace manual fetching to options
# FIXME: Catppuccin color may not match flavour. Fixed by above todo or workaround
let
  catlock_repo = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprlock";
    rev = "d5a6767000409334be8413f19bfd1cf5b6bb5cc6";
    sha256 = "sha256-pjMFPaonq3h3e9fvifCneZ8oxxb1sufFQd7hsFe6/i4=";
  };
  catland_repo = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "hyprland";
    rev = "b57375545f5da1f7790341905d1049b1873a8bb3";
    sha256 = "sha256-XTqpmucOeHUgSpXQ0XzbggBFW+ZloRD/3mFhI+Tq4O8=";
  };
in
{
  # TODO: Try not to fetch to use local files for Backgrounds etc.
  home.file = {
    ".config/hypr/hyprlock.conf".source = catlock_repo + "/hyprlock.conf";
    ".config/hypr/mocha.conf".source = catland_repo + "/themes/mocha.conf";
  };
  programs.hyprlock = {
    enable = true;
    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
  };
}
