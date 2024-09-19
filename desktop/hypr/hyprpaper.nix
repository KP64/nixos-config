{
  lib,
  config,
  username,
  ...
}:

let
  files = map toString (lib.filesystem.listFilesRecursive ../wallpapers);

  extensions = map (x: ".${x}") [
    "png"
    "jpg"
  ];

  # -- DESC --
  # Will generate a list with and without extension.
  # -- CODE --
  # "xxx.png"
  # turns to
  # [ "xxx" "xxx.png" ]
  removeExt = name: map (ext: lib.removeSuffix ext name) extensions;

  # -- DESC --
  # Removes the Keys where the extension wasn't filtered.
  # -- CODE --
  # [ "xxx" "xxx.png" ]
  # turns to
  # [ "xxx" ]
  removeKeysWithExt =
    list: builtins.filter (name: !(builtins.any (ext: lib.hasSuffix ext name) extensions)) list;

  wallpapers = builtins.listToAttrs (
    map (
      name:
      let
        dedupped = removeKeysWithExt (removeExt (baseNameOf name));
        # removeKeysWithExt guarantees exactly one entry.
        # Namely the entry with key without extension.
        stripped = builtins.elemAt dedupped 0;
      in
      lib.nameValuePair stripped name
    ) files
  );

  active_wallpaper = wallpapers.colorful-planets;
in
{
  options.desktop.hypr.hyprpaper.enable = lib.mkEnableOption "Enables Hyprpaper";

  config = lib.mkIf config.desktop.hypr.hyprpaper.enable {
    home-manager.users.${username}.services.hyprpaper = {
      enable = true;
      settings = {
        preload = active_wallpaper;
        wallpaper = [ ", ${active_wallpaper}" ];
      };
    };
  };
}
