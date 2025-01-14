{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:
let
  cfg = config.desktop.hypr.hyprpanel;

  inherit (config.lib.stylix) colors;

  accent = "#${colors.base0D}";
  accent-alt = "#${colors.base03}";
  background = "#${colors.base00}";
  background-alt = "#${colors.base01}";
  foreground = "#${colors.base05}";

  hyprpanel-reload = pkgs.writers.writeBashBin "hyprpanel-reload" ''
    [ $(pgrep "hyprpanel") ] && pkill hyprpanel
    hyprctl dispatch exec hyprpanel
  '';
in
{
  options.desktop.hypr.hyprpanel.enable = lib.mkEnableOption "Hyprpanel";

  config = lib.mkIf cfg.enable {
    home-manager.users.${username} = {
      wayland.windowManager.hyprland.settings.exec-once = [ "hyprpanel" ];

      home.packages = [
        inputs.hyprpanel.packages.${pkgs.system}.default
        hyprpanel-reload
      ];

      # TODO: Right now weather Key doesn't work with sops-nix.
      # Wait for Hyprpanel to provide support i.e. an option that expect a path.
      xdg.configFile."hyprpanel/config.json".text =
        let
          stylixOnly = lib.optionalString config.isStylixEnabled ''
            "theme.bar.transparent": true,

            "theme.bar.buttons.workspaces.hover": "${accent-alt}",
            "theme.bar.buttons.workspaces.active": "${accent}",
            "theme.bar.buttons.workspaces.available": "${accent-alt}",
            "theme.bar.buttons.workspaces.occupied": "${accent}",

            "theme.bar.menus.monochrome": true,
            "theme.bar.menus.background": "${background}",
            "theme.bar.menus.cards": "${background-alt}",
            "theme.bar.menus.label": "${foreground}",
            "theme.bar.menus.text": "${foreground}",
            "theme.bar.menus.border.color": "${accent}",
            "theme.bar.menus.popover.text": "${foreground}",
            "theme.bar.menus.popover.background": "${background-alt}",
            "theme.bar.menus.listitems.active": "${accent}",
            "theme.bar.menus.icons.active": "${accent}",
            "theme.bar.menus.switch.enabled":"${accent}",
            "theme.bar.menus.check_radio_button.active": "${accent}",
            "theme.bar.menus.buttons.default": "${accent}",
            "theme.bar.menus.buttons.active": "${accent}",
            "theme.bar.menus.iconbuttons.active": "${accent}",
            "theme.bar.menus.progressbar.foreground": "${accent}",
            "theme.bar.menus.slider.primary": "${accent}",
            "theme.bar.menus.tooltip.background": "${background-alt}",
            "theme.bar.menus.tooltip.text": "${foreground}",
            "theme.bar.menus.dropdownmenu.background":"${background-alt}",
            "theme.bar.menus.dropdownmenu.text": "${foreground}",
            "theme.bar.buttons.style": "default",
            "theme.bar.buttons.monochrome": true,
            "theme.bar.buttons.text": "${foreground}",
            "theme.bar.buttons.icon": "${accent}",
            "theme.bar.buttons.notifications.background": "${background-alt}",
            "theme.bar.buttons.hover": "${background}",
            "theme.bar.buttons.notifications.hover": "${background}",
            "theme.bar.buttons.notifications.total": "${accent}",
            "theme.bar.buttons.notifications.icon": "${accent}",
            "theme.notification.background": "${background-alt}",
            "theme.notification.actions.background": "${accent}",
            "theme.notification.actions.text": "${foreground}",
            "theme.notification.label": "${accent}",
            "theme.notification.border": "${background-alt}",
            "theme.notification.text": "${foreground}",
            "theme.notification.labelicon": "${accent}",
            "theme.osd.bar_color": "${accent}",
            "theme.osd.bar_overflow_color": "${accent-alt}",
            "theme.osd.icon": "${background}",
            "theme.osd.icon_container": "${accent}",
            "theme.osd.label": "${accent}",
            "theme.osd.bar_container": "${background-alt}",
            "theme.bar.menus.menu.media.background.color": "${background-alt}",
            "theme.bar.menus.menu.media.card.color": "${background-alt}",
            "theme.bar.menus.menu.media.card.tint": 90,
          '';
        in
        ''
          {
            ${stylixOnly}

            "wallpaper.enable": false,
            "hyprpanel.restartCommand": "hyprpanel -q; hyprpanel",

            "bar.media.show_active_only": true,
            "bar.customModules.updates.pollingInterval": 1440000,
            "bar.windowtitle.label": false,
            "bar.launcher.icon": "",
            "bar.layouts": {
              "*": {
                "left": [
                  "dashboard",
                  "workspaces"
                ],
                "middle": [ "media" ],
                "right": [
                  "network",
                  "volume",
                  "bluetooth",
                  "systray",
                  "clock",
                  "hyprsunset",
                  "notifications"
                ]
              }
            },

            "bar.workspaces.show_numbered": true,
            "bar.workspaces.workspaces": ${toString config.maxWorkspaceCount},
            "bar.workspaces.monitorSpecific": true,

            "menus.clock.weather.location": "",
            "menus.clock.weather.key": "",
            "menus.clock.weather.unit": "metric",

            "menus.dashboard.shortcuts.left.shortcut1.icon": "",
            "menus.dashboard.shortcuts.left.shortcut1.command": "firefox",
            "menus.dashboard.shortcuts.left.shortcut1.tooltip": "Firefox",
            "menus.dashboard.shortcuts.left.shortcut2.icon": "",
            "menus.dashboard.shortcuts.left.shortcut2.command": "spotify",
            "menus.dashboard.shortcuts.left.shortcut2.tooltip": "Spotify",
            "menus.dashboard.shortcuts.left.shortcut3.icon": "",
            "menus.dashboard.shortcuts.left.shortcut3.command": "vesktop",
            "menus.dashboard.shortcuts.left.shortcut3.tooltip": "Vesktop",

            "menus.dashboard.shortcuts.right.shortcut1.icon": "",
            "menus.dashboard.shortcuts.right.shortcut1.command": "hyprpicker -a",
            "menus.dashboard.shortcuts.right.shortcut1.tooltip": "Color Picker",
            "menus.dashboard.shortcuts.right.shortcut3.icon": "󰄀",
            "menus.dashboard.shortcuts.right.shortcut3.command": "grimblast --freeze --notify copysave area",
            "menus.dashboard.shortcuts.right.shortcut3.tooltip": "Screenshot",

            "menus.dashboard.directories.left.directory1.label": "󰉍 Downloads",
            "menus.dashboard.directories.left.directory1.command": "bash -c \"thunar $HOME/Downloads/\"",
            "menus.dashboard.directories.left.directory2.label": "󰉏 Pictures",
            "menus.dashboard.directories.left.directory2.command": "bash -c \"thunar $HOME/Pictures/\"",
            "menus.dashboard.directories.left.directory3.label": "󱧶 Documents",
            "menus.dashboard.directories.left.directory3.command": "bash -c \"thunar $HOME/Documents/\"",
            "menus.dashboard.directories.right.directory1.label": "󱂵 Home",
            "menus.dashboard.directories.right.directory1.command": "bash -c \"thunar $HOME/\"",
            "menus.dashboard.directories.right.directory2.label": "󰚝 Projects",
            "menus.dashboard.directories.right.directory2.command": "bash -c \"thunar $HOME/dev/\"",
            "menus.dashboard.directories.right.directory3.label": " Config",
            "menus.dashboard.directories.right.directory3.command": "bash -c \"thunar $HOME/.config/\""
          }
        '';
    };
  };
}
