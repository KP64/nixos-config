{ lib, self }:
{
  /**
    This function returns a list with
    the names of all directories and all
    files with the ".nix" extension except
    for default.nix of the specified path

    # Example

    ```nix
    scanPath "${self}/hosts/nixos/aladdin"
    =>
    [
      "default.nix"
      "disko-config.nix"
    ]
    ```

    # Type

    ```
    scanPath :: Path -> [ String ]
    ```

    # Arguments

    path
    : The path to be scanned
  */
  scanPath =
    path:
    path
    |> builtins.readDir
    |> lib.filterAttrs (
      path: type: (type == "directory") || (path != "default.nix" && lib.hasSuffix ".nix" path)
    )
    |> builtins.attrNames
    |> map (f: "${path}/${f}");

  /**
    Takes in a list of usernames and returns
    a list with the corresponsing nixos
    configuration file of each user.

    # Example

    ```
    getUserNixOSConfigs [ "kg" ]
    =>
    [ "${self}/users/kg/nixos.nix" ]
    ```

    # Type

    ```
    getUserNixOSConfigs :: [ String ] -> [ String ]
    ```

    # Arguments

    userList
    : The list of usernames
  */
  getUserNixOSConfigs = userList: userList |> map (user: "${self}/users/${user}/nixos.nix");

  /**
    Takes in a list of usernames and returns
    a list with the corresponsing Home-Manager
    configuration of each user.

    # Example

    ```
    getUserHomeConfigs [ "kg" ]
    =>
    [ { home-manager.users.kg = { ... }; } ]
    ```

    # Type

    ```
    getUserHomeConfigs :: [ String ] -> [ AttrSet ]
    ```

    # Arguments

    userList
    : The list of usernames
  */
  getUserHomeConfigs =
    userList:
    userList
    |> map (user: {
      home-manager.users.${user} = lib.mkMerge [
        "${self}/users/${user}/home.nix"
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
