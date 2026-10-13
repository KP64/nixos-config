toplevel: {
  den = {
    schema.host.options.isGamingCapable = toplevel.lib.mkEnableOption "Machine is for Gaming";

    aspects.gaming = { lib, ... }: {
      nixos =
        { host, pkgs, ... }:
        lib.optionalAttrs host.isGamingCapable {
          boot.kernelPackages = pkgs.linuxPackages_zen;
          # NOTE: Locking kernel prevents a controller's kernel module to load. (e.g. hid_playstation)
          security.lockKernelModules = lib.mkForce false;
        };

      _ = {
        steam =
          { host, den, ... }:
          lib.optionalAttrs host.isGamingCapable {
            includes = [
              den.aspects.gaming
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
                  enableWsi = true;
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

        lutris =
          { host, den, ... }:
          lib.optionalAttrs host.isGamingCapable {
            includes = [ den.aspects.gaming ];

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
                nixosConfig ? null,
                pkgs,
                ...
              }:
              {
                programs.lutris = {
                  enable = true;
                  defaultWinePackage = pkgs.proton-ge-bin;
                  winePackages = [ pkgs.wineWow64Packages.full ];
                  protonPackages = [ pkgs.proton-ge-bin ];
                  steamPackage = nixosConfig.programs.steam.package or pkgs.steam;
                };
              };
          };
      };
    };
  };
}
