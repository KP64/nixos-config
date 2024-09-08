{
  pkgs,
  lib,
  config,
  username,
  ...
}:
{
  options.cli.ricing.fetchers.enable = lib.mkEnableOption "Enables Some Fetchers";

  config = lib.mkIf config.cli.ricing.fetchers.enable {
    home-manager.users.${username} = {
      home.packages = with pkgs; [
        onefetch
        cpufetch
        # gpufetch # Not available on nixpkgs
      ];

      programs.fastfetch.enable = true;
    };
  };
}
