{
  lib,
  config,
  username,
  ...
}:
{
  options.editors.helix.enable = lib.mkEnableOption "Enable Helix Editor";

  config = lib.mkIf config.editors.helix.enable {
    home-manager.users.${username}.programs.helix = {
      enable = true;
      defaultEditor = true;
      settings.editor = {
        true-color = true;
        file-picker.hidden = false;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
