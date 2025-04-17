{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.cli.navi;
in
{
  options.cli.navi.enable = lib.mkEnableOption "Navi";

  config.programs.navi = {
    inherit (cfg) enable;
    settings.cheats.paths = with inputs; [
      navi-papanito-cheats
      navi-denis-cheats
      navi-denis-dotfiles
      navi-denis-tldr-pages
    ];
  };
}
