{ inputs }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  getUsers = userList: userList |> map (user: "${inputs.self}/users/${user}/nixos.nix");

  getHomes =
    userList:
    userList
    |> map (user: {
      home-manager.users.${user} = lib.mkMerge [
        "${inputs.self}/users/${user}/home.nix"
        {
          programs.home-manager.enable = true;
          home = {
            username = user;
            homeDirectory = "/home/${user}";
          };
        }
      ];
    });
}
