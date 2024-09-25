{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  imports = [
    ./cava.nix
    ./fetchers.nix
  ];

  options.cli.ricing.defaults.enable = lib.mkEnableOption "Enable Default Ricing Apps";

  config = lib.mkIf config.cli.ricing.defaults.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      cbonsai
      pipes-rs
      cmatrix
    ];
  };
}
