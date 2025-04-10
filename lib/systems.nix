{ inputs, rootPath }:
let
  inherit (inputs.nixpkgs) lib;

  getNames =
    filetype: path:
    path |> builtins.readDir |> lib.filterAttrs (_: v: v == filetype) |> builtins.attrNames;

  getDirNames = getNames "directory";

  getUsersPath = hostPath: lib.path.append hostPath "users";

  getHosts =
    platform:
    let
      platformPath = "${rootPath}/hosts/${platform}";
    in
    platformPath
    |> getDirNames
    |> map (
      arch:
      "${platformPath}/${arch}"
      |> getDirNames
      |> map (host: {
        ${host}.system = arch;
      })
    )
    |> lib.flatten
    |> lib.mergeAttrsList;

  getHomes =
    hostPath:
    hostPath
    |> getUsersPath
    |> lib.fileset.fileFilter (file: file.name == "home.nix")
    |> lib.fileset.toList
    |> map (home: {
      username = baseNameOf <| dirOf <| home;
      inherit home;
    })
    |> map (
      { username, home }:
      {
        home-manager.users.${username} = lib.mkMerge [
          home
          {
            programs.home-manager.enable = true;
            home = {
              inherit username;
              homeDirectory = "/home/${username}";
            };
          }
        ];
      }
    );

  getUsers =
    hostPath:
    let
      usersPath = getUsersPath hostPath;
    in
    usersPath |> getDirNames |> map (u: "${usersPath}/${u}");
in
{
  inherit getHosts getHomes getUsers;
}
