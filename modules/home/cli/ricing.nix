{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.ricing;

  rain = pkgs.writeShellApplication {
    name = "rain";
    text = ''
      trap "exit 0" SIGINT

      while true; do
        if read -rsn1 -t 0.01 key && [[ $key == q ]]; then
          break
        fi

        c=$(( $(date +%s%N) % 8 ))
        printf "\033[1;3%sm." "$c"
      done
    '';
  };
in
{
  options.cli.ricing.enable = lib.mkEnableOption "All ricing";

  config = lib.mkIf cfg.enable {
    programs = {
      cava.enable = true;
      clock-rs.enable = true;
    };

    home.packages = with pkgs; [
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
      rain
    ];
  };
}
