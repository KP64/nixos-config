{
  flake.modules.nixos.hosts-aladdin =
    { pkgs, ... }:
    {
      allowedUnfreePackages = [
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
