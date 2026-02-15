{
  flake.aspects.hosts-aladdin.nixos =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      allowedUnfreePackages = lib.optionals config.programs.steam.enable [
        "steam"
        "steam-unwrapped"
      ];

      programs = {
        gamemode.enable = true;
        gamescope = {
          enable = true;
          capSysNice = true;
        };
        steam = {
          enable = true;
          extest.enable = true;
          gamescopeSession.enable = true;
          protontricks.enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
      };
    };
}
