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
      home.packages =
        with pkgs;
        [
          onefetch
          cpufetch
        ]
        ++ lib.optional (pkgs.system == "x86_64-linux") pkgs.gpufetch;

      programs.fastfetch.enable = true;
    };
  };
}
