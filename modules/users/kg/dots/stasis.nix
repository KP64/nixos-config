{ inputs, ... }:
{
  flake.modules.homeManager.users-kg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.stasis.homeModules.default ];

      # Needed for the notify_before commands
      home.packages = [ pkgs.libnotify ];

      services.stasis = {
        enable = true;
        extraConfig =
          let
            lockCMD =
              if (config.programs.noctalia-shell.enable or false) then
                "noctalia-shell ipc call lockScreen lock"
              else
                "${lib.getExe pkgs.systemdMinimal "loginctl"} lock-session";

            dpmsCMD =
              if config.wayland.windowManager.hyprland.enable then
                {
                  on = "hyprctl dispatch dpms off";
                  off = "hyprctl dispatch dpms on";
                }
              else if (config.programs.niri.enable or false) then
                {
                  on = "niri msg action power-off-monitors";
                  off = "niri msg action power-on-monitors";
                }
              else
                throw "No WM enabled";

            systemctl = lib.getExe' pkgs.systemdMinimal "systemctl";
            brightnessctl = lib.getExe pkgs.brightnessctl;
          in
          ''
            @author "${config.home.username}"
            @description "Stasis configuration file"

            default:
              pre_suspend_command "${lockCMD}"
              monitor_media true
              ignore_remote_media true
              debounce_seconds 5

              # When resuming from IPC pause timers (e.g. `stasis pause 1h`)
              notify_on_unpause true

              # Enables per-step notifications (only if the block sets `notification`)
              notify_before_action true

              startup:
                timeout 0
                command "notify-send -a Stasis 'Stasis started!'"
              end

              lock_screen:
                timeout 120
                use_loginctl true
                command "${lockCMD}"
                resume_command "notify-send 'Welcome Back $env.USER!'"
                notification "Locking session in 10s"
                notify_seconds_before 10
              end

              dpms:
                timeout 60
                command "${dpmsCMD.off}"
                resume_command "${dpmsCMD.on}"
              end

              suspend:
                timeout 1800
                command "${systemctl} suspend"
              end

              ac:
                # instant action: timeout 0 runs immediately when AC becomes active
                custom_brightness_instant:
                  timeout 0
                  command "${brightnessctl} set 100%"
                end

                brightness:
                  timeout 120
                  command "${brightnessctl} set 30%"
                end

                dpms:
                  timeout 60
                  command "${dpmsCMD.off}"
                  resume_command "${dpmsCMD.on}"
                end

                lock_screen:
                  timeout 120
                  use_loginctl true
                  command "${lockCMD}"
                  notification "Locking on AC in 10s"
                  notify_seconds_before 10
                end

                suspend:
                  timeout 300
                  command "${systemctl} suspend"
                end
              end

              battery:
                custom_brightness_instant:
                  timeout 0
                  command "${brightnessctl} set 40%"
                end

                brightness:
                  timeout 60
                  command "${brightnessctl} set 20%"
                end

                dpms:
                  timeout 30
                  command "${dpmsCMD.off}"
                  resume_command "${dpmsCMD.on}"
                end

                lock_screen:
                  timeout 120
                  use_loginctl true
                  command "${lockCMD}"
                  resume_command "notify-send 'Welcome back $env.USER!'"
                end

                suspend:
                  timeout 120
                  command "${systemctl} suspend"
                end
              end
            end


            gaming:
              mode "overlay"   # merges on top of active base (desktop/default OR laptop/ac/battery)

              # Override globals (example: add/replace inhibitors)
              inhibit_apps [
                r".*\.exe"
                r"steam_app_.*"
                r".*\.x86_64"
              ]
            end
          '';
      };
    };
}
