{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfg = config.system.style.stylix;
in
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  options = {
    isStylixEnabled = lib.mkOption {
      internal = true;
      type = lib.types.bool;
      default = cfg.enable;
    };

    system.style.stylix = {
      enable = lib.mkEnableOption "Stylix";
      polarity = lib.mkOption {
        default = "either";
        type = lib.types.enum [
          "either"
          "light"
          "dark"
        ];
        example = "dark";
        description = "Whether to force light or dark mode.";
      };
      scheme = lib.mkOption {
        default = "gruvbox-dark-hard";
        type = lib.types.nonEmptyStr;
        example = "synth-midnight-dark";
        description = ''
          The Base16 Color Scheme to use.
          Refer to https://github.com/tinted-theming/schemes/tree/spec-0.11/base16
          for the possibilites.
        '';
      };
      wallpaper = lib.mkOption {
        default = ../../desktop/wallpapers/wallhaven.jpg;
        type = lib.types.path;
        example = ../../desktop/wallpapers/windows-error.jpg;
        description = "The wallpaper to be applied.";
      };
      iconPack = lib.mkOption {
        default = {
          package = pkgs.gruvbox-plus-icons;
          name = "Gruvbox-Plus-Dark";
        };
        type = lib.types.submodule {
          options = {
            package = lib.mkOption {
              type = lib.types.package;
              description = "The Icon Package.";
              example = pkgs.gruvbox-plus-icons;
            };
            name = lib.mkOption {
              type = lib.types.nonEmptyStr;
              description = "The name of the IconPack.";
              example = "Gruvbox-Plus-Light";
            };
          };
        };
      };
    };
  };

  config =
    let
      stylix = {
        inherit (cfg) enable polarity;
        image = cfg.wallpaper;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.scheme}.yaml";

        fonts.monospace = {
          package = pkgs.nerd-fonts.dejavu-sans-mono;
          name = "DejaVuSansM Nerd Font";
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };
      };
    in
    {
      inherit stylix;
      home-manager.users.${username} = {
        stylix = stylix // {
          iconTheme = {
            enable = true;
            inherit (cfg.iconPack) package;
            dark = cfg.iconPack.name;
            light = cfg.iconPack.name;
          };
        };
      };
    };
}
