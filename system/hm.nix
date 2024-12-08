{
  inputs,
  username,
  stateVersion,
  ...
}:

{
  imports = [ inputs.hm.nixosModules.default ];

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
