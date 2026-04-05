toplevel@{ inputs, ... }:
{
  flake.modules = {
    nixos.home-manager =
      { config, ... }:
      {
        imports = [ inputs.home-manager.nixosModules.default ];

        # TODO: Refine the config to support useGlobalPkgs
        #       without it being a hassle
        home-manager = {
          startAsUserService = true;
          useUserPackages = true;
          overwriteBackup = true;
          backupFileExtension = "hm-backup";
          sharedModules = [
            toplevel.config.flake.modules.homeManager.hostname
            { hostname = config.networking.hostName; }
          ];
        };
      };

    # NOTE: This should be imported by HM-Only devices
    homeManager.home-manager = {
      programs.home-manager.enable = true;
    };
  };
}
