{
  config,
  lib,
  inputs,
  username,
  ...
}:
let
  cfg = config.system.style.catppuccin;

  accents = [
    "blue"
    "flamingo"
    "green"
    "lavender"
    "maroon"
    "mauve"
    "peach"
    "pink"
    "red"
    "rosewater"
    "sapphire"
    "sky"
    "teal"
    "yellow"
  ];

  cursorAccents = accents ++ [
    "dark"
    "light"
  ];
in
{
  imports = [ inputs.catppuccin.nixosModules.catppuccin ];

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
        type = lib.types.enum accents;
        description = "What Accent Catppuccin should use.";
        example = "rosewater";
      };

      cursorAccent = lib.mkOption {
        default = "dark";
        type = lib.types.enum cursorAccents;
        description = "What Accent the desktop cursor should use.";
        example = "lavender";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      inherit (cfg) accent;
      cache.enable = true;
    };
    home-manager.users.${username} = {
      imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];

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
  };
}
