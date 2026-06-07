{ den, ... }: {
  den.aspects.gaming._ = {
    steam = {
      includes = [
        (den.batteries.unfree [
          "steam"
          "steam-unwrapped"
        ])
      ];

      nixos = { pkgs, ... }: {
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
    };

    lutris = {
      # https://github.com/lutris/docs/blob/master/HowToEsync.md
      # https://wiki.nixos.org/wiki/Lutris#Using_Esync
      nixos =
        let
          NOFILE = 524288;
        in
        {
          systemd.settings.Manager.DefaultLimitNOFILE = NOFILE;
          security.pam.loginLimits = [
            {
              domain = "@wheel";
              type = "hard";
              item = "nofile";
              value = NOFILE;
            }
          ];
        };
      homeManager =
        {
          osConfig ? null,
          pkgs,
          ...
        }:
        {
          programs.lutris = {
            enable = true;
            defaultWinePackage = pkgs.proton-ge-bin;
            winePackages = [ pkgs.wineWow64Packages.full ];
            protonPackages = [ pkgs.proton-ge-bin ];
            steamPackage = osConfig.programs.steam.package or pkgs.steam;
          };
        };
    };
  };
}
