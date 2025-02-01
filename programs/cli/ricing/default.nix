{
  pkgs,
  lib,
  config,
  username,
  ...
}:
let
  cfg = config.cli.ricing;
in
{
  imports = [
    ./cava.nix
    ./fetchers.nix
  ];

  options.cli.ricing = {
    enable = lib.mkEnableOption "All ricing";
    misc.enable = lib.mkEnableOption "Some Ricing Apps";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      cli.ricing = {
        cava.enable = lib.mkDefault true;
        fetchers.enable = lib.mkDefault true;
        misc.enable = lib.mkDefault true;
      };
    })

    {
      home-manager.users.${username}.home.packages = lib.optionals cfg.misc.enable (
        with pkgs;
        [
          cbonsai
          cfonts
          cmatrix
          genact
          nms
          pipes-rs
        ]
      );
    }
  ];
}
