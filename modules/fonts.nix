let
  fonts =
    pkgs:
    [ pkgs.font-awesome ]
    ++ (with pkgs.nerd-fonts; [
      jetbrains-mono
      symbols-only
    ]);
in
{
  flake.modules = {
    nixos.fonts =
      { pkgs, ... }:
      {
        fonts.packages = fonts pkgs;
      };

    homeManager.fonts =
      { pkgs, ... }:
      {
        fonts.fontconfig.enable = true;
        home.packages = fonts pkgs;
      };
  };
}
