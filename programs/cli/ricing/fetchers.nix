{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.cli.ricing.fetchers.enable = lib.mkEnableOption "Fetchers";

  config = lib.mkIf config.cli.ricing.fetchers.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        onefetch
        cpufetch
        # TODO: Package
        # gpufetch # Not available on nixpkgs
      ];

      programs.fastfetch.enable = true;
    };
  };
}
