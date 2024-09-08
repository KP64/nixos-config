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

  options.cli.ricing.enable = lib.mkEnableOption "Enable Default Ricing Apps";

  config = lib.mkIf config.cli.ricing.enable {
    home-manager.users.${username}.home.packages = with pkgs; [
      cbonsai
      pipes-rs
    ];
  };
}
