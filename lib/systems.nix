{ inputs, rootPath }:
let
  inherit (inputs.nixpkgs) lib;

  # -- DESC --
  # Gets All directory Names from the specified path
  # -- CODE --
  # getDirNames ../.
  # turns to
  # [ "hosts" "lib" "modules" ]
  getDirNames =
    path: path |> builtins.readDir |> lib.filterAttrs (_: v: v == "directory") |> builtins.attrNames;

  getUsersPath = hostPath: lib.path.append hostPath "users";

  # -- DESC --
  # Gets all hosts of a specific platform and their architecture
  # Platforms would be one of e.g. "nixos" or "droid"
  # -- CODE --
  # getHosts "nixos"
  # turns to
  # {
  #   aladdin = { system = "x86_64-linux"; };
  #   alibaba = { system = "x86_64-linux"; };
  #   sindbad = { system = "x86_64-linux"; };
  # }
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

  # -- DESC --
  # Gets all users of a specific host,
  # that have a home.nix file and imports
  # them in home-manager with a default homeDirectory
  # -- CODE --
  # getHomes ../hosts/nixos/x86_64-linux/aladdin
  # turns to
  # [
  #   { home-manager.users.kg = { ... }; }
  #   ...
  # ]
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

  # -- DESC --
  # Returns a list of all users of a specific host
  # -- CODE --
  # getUsers ../hosts/nixos/x86_64-linux/aladdin
  # turns to
  # [
  #   "kg"
  #   ...
  # ]
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
