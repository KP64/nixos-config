{ inputs, ... }: {
  flake-file.inputs.home-manager = {
    type = "github";
    owner = "nix-community";
    repo = "home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.home-manager.flakeModules.home-manager ];

  den.default =
    let
      defaults = {
        overwriteBackup = true;
        backupFileExtension = "hm-backup";
      };
    in
    {
      nixos.home-manager = defaults // {
        startAsUserService = true;
        useUserPackages = true;
        useGlobalPkgs = true;
        overwriteBackup = true;
        backupFileExtension = "hm-backup";
      };

      homeManager.home = defaults // {
        preferXdgDirectories = true;
      };
    };
}
