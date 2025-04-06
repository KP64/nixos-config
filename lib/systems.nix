{ inputs, rootPath }:
let
  inherit (inputs.nixpkgs) lib;

  getNames =
    filetype: path:
    path |> builtins.readDir |> lib.filterAttrs (_: v: v == filetype) |> builtins.attrNames;

  getDirNames = getNames "directory";
  getFileNames = getNames "regular";

  getHosts =
    platform:
    let
      platformPath = "${rootPath}/hosts/${platform}";
    in
    platformPath
    |> getDirNames
    |> map (
      arch:
      (getDirNames "${platformPath}/${arch}")
      |> map (host: {
        ${host} = {
          hostName = host;
          system = arch;
        };
      })
    )
    |> lib.flatten
    |> lib.mergeAttrsList;

  getHomes =
    path:
    let
      homesPath = "${path}/homes";
    in
    homesPath
    |> getFileNames
    |> map (
      u:
      let
        username = lib.removeSuffix ".nix" u;
      in
      {
        home-manager.users.${username} = lib.mkMerge [
          "${homesPath}/${u}"
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
    path:
    let
      userPath = "${path}/users";
    in
    userPath
    |> getFileNames
    |> map (
      u:
      let
        user = lib.removeSuffix ".nix" u;
      in
      {
        users.users.${user} = import "${userPath}/${u}";
      }
    );
in
{
  inherit getHosts getHomes getUsers;
}
