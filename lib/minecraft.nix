{
  /**
    Takes in an Attribute of mods and
    generates a derivation of them.

    # Example

    ```nix
    collectMods {
      inherit pkgs;
      mods = {
        ALTERNATE_CURRENT = {
          url = "https://cdn.modrinth.com/data/r0v8vy1s/versions/eTNKfjl1/alternate-current-mc1.21.5-1.9.0.jar";
          sha512 = "3e4088170917846b30275825420b553e3fc3befb52bb259848853b93343bae3b39cd592902c0c79f05b17381d80170784990d9c4e110ff3b6c552e5508b40d67";
        };
      };
    }
    =>
    Derivation
    ```

    # Type

    ```
    collectMods :: { pkgs :: a; mods :: AttrSet }
    ```

    # Arguments

    pkgs
    : The instance of your nixpkgs

    mods
    : The mods Attrset
  */
  collectMods =
    { pkgs, mods }: mods |> builtins.attrValues |> map pkgs.fetchurl |> pkgs.linkFarmFromDrvs "mods";
}
