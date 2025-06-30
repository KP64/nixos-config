{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.cli.ricing;
in
{
  imports = [ inputs.trmt.homeManagerModules.default ];

  options.cli.ricing.enable = lib.mkEnableOption "All ricing";

  config = lib.mkIf cfg.enable {
    home.packages =
      [ inputs.dotz.packages.${pkgs.system}.default ]
      ++ (with inputs.self.packages.${pkgs.system}; [
        mufetch
        terminal-rain-lightning
      ])
      ++ (with pkgs; [
        cbonsai
        cfonts
        cmatrix
        dwt1-shell-color-scripts
        figlet
        genact
        nms
        pipes-rs
        rust-stakeholder
        tenki
        toilet
        tty-clock
      ]);
    programs = {
      cava.enable = true;
      clock-rs.enable = true;
      trmt = {
        enable = true;
        config = lib.mkDefault {
          simulation = {
            autoplay = true;
            heads = 3;
            rule = "RL";
            speed_ms = 20;
            trail_length = 30;
            color_cells = true;
            seed = "";
          };
          display = {
            keycast = false;
            colors = [
              "rgb(241, 113, 54)"
              "#45a8e9"
              "229"
            ];
            fade_trail_color = "";
            state_based_colors = false;
            live_colors = false;
            head_char = [ "██" ];
            trail_char = [ "▓▓" ];
            cell_char = "░░";
            randomize_heads = false;
            randomize_trails = false;
          };
          controls = {
            quit = "q";
            toggle = " ";
            reset = "r";
            faster = "+";
            slower = "-";
            config_reload = "c";
            help = "h";
            statusbar = "b";
            randomize_seed = "s";
            randomize_rule = "n";
            randomize = "R";
          };
        };
      };
    };
  };
}
