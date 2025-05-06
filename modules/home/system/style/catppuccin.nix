{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.system.style.catppuccin;
in
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  options = {
    isCatppuccinEnabled = lib.mkOption {
      type = lib.types.bool;
      default = cfg.enable;
      internal = true;
    };

    system.style.catppuccin = {
      enable = lib.mkEnableOption "Catppuccin";

      enableGtkIcons = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = "Enable Catppuccin Icons for GTK.";
        example = false;
      };

      accent = lib.mkOption {
        default = "lavender";
        type = lib.types.nonEmptyStr;
        description = "What Accent Catppuccin should use.";
        example = "rosewater";
      };

      cursorAccent = lib.mkOption {
        default = "dark";
        type = lib.types.nonEmptyStr;
        description = "What Accent the desktop cursor should use.";
        example = "lavender";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # TODO: Reenable when https://github.com/catppuccin/nix/issues/552 is closed
    catppuccin.mako.enable = false;

    catppuccin = {
      enable = true;
      inherit (cfg) accent;
      gtk.icon.enable = cfg.enableGtkIcons;
      cursors = {
        enable = true;
        accent = cfg.cursorAccent;
      };
    };

    home.pointerCursor.hyprcursor.enable = true;

    gtk = lib.genAttrs [ "gtk3" "gtk4" ] (_: {
      extraConfig.gtk-application-prefer-dark-theme = 1;
    });

    qt =
      let
        name = "kvantum";
      in
      {
        style = { inherit name; };
        platformTheme = { inherit name; };
      };
  };
}
