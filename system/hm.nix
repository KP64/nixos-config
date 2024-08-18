{
  inputs,
  username,
  stateVersion,
  ...
}:

{
  imports = [ inputs.hm.nixosModules.default ];

  home-manager = {
    extraSpecialArgs = {
      inherit username stateVersion;
    };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      programs.home-manager.enable = true;
      home = {
        inherit username stateVersion;
        homeDirectory = "/home/${username}";
        pointerCursor = {
          gtk.enable = true;
          x11 = {
            enable = true;
            defaultCursor = "catppuccin-mocha-dark-cursors";
          };
          size = 24;
        };
      };
    };
  };
}
