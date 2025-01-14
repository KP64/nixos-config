{
  inputs,
  username,
  stateVersion,
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.default ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    users.${username} = {
      programs.home-manager.enable = true;
      home = {
        inherit username stateVersion;
        homeDirectory = "/home/${username}";
      };
    };
  };
}
