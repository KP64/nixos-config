{
  flake.modules.homeManager.users-kg =
    { config, pkgs, ... }:
    let
      inherit (config.lib.formats.rasi) mkLiteral;
    in
    {
      programs.rofi = {
        enable = true;
        plugins = with pkgs; [
          rofi-emoji
          rofi-calc
        ];

        modes = [
          "run"
          "drun"
          "window"
          "emoji"
          "calc"
        ];

        cycle = false;

        theme = {
          window = rec {
            width = 600;
            height = width;

            border = 3;
            border-radius = 10;
            border-color = mkLiteral "@lavender";
          };

          mainbox.children = mkLiteral "[inputbar, message, listview]";

          inputbar = {
            color = mkLiteral "@text";
            padding = 14;
            background-color = "@base";
          };

          listview = {
            border = mkLiteral "2 2 2 2";
            border-color = mkLiteral "@base";
            background-color = mkLiteral "@base";
          };

          "entry, prompt, case-indicator" = {
            text-color = mkLiteral "inherit";
          };

          element = {
            padding = 5;
            vertical-align = mkLiteral "0.5";
            border-radius = 10;
            background-color = mkLiteral "@surface0";
          };

          "element.selected.normal" = {
            background-color = mkLiteral "@overlay0";
          };

          "element.alternate.normal" = {
            background-color = mkLiteral "inherit";
          };

          "element.normal.active, element.alternate.active" = {
            background-color = mkLiteral "@peach";
          };

          "element.selected.active" = {
            background-color = mkLiteral "@green";
          };

          "element.normal.urgent, element.alternate.urgent" = {
            background-color = "@red";
          };

          "element.selected.urgent" = {
            background-color = mkLiteral "@mauve";
          };

          "element-text, element-icon" = {
            size = 40;
            vertical-align = mkLiteral "0.5";
            background-color = mkLiteral "inherit";
            text-color = mkLiteral "@text";
          };

          "element-text .active, element-text .urgent" = {
            text-color = mkLiteral "@base";
          };
        };
      };
    };
}
