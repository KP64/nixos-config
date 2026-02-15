{
  flake.aspects.yubikey = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        options.yubi = lib.mkOption {
          default.mode = "normal";
          example = {
            mode = "strict";
            logoutOnRemoval = false;
          };
          type = lib.types.submodule (submod: {
            options = {
              mode = lib.mkOption {
                default = "normal";
                type = lib.types.enum [
                  "normal"
                  "strict"
                ];
                example = "strict";
                description = "The mode determines predefined values of yubikey rules";
              };
              logoutOnRemoval = lib.mkOption {
                default = submod.config.mode == "strict";
                type = lib.types.bool;
                example = false;
                description = "Whether to lock the session on yubikey removal";
              };
            };
          });
        };

        config = lib.mkMerge [
          {
            programs.yubikey-manager.enable = true;
            services.yubikey-agent.enable = true;
            security.pam.yubico = {
              enable = true;
              mode = "challenge-response";
              control = if config.yubi.mode == "strict" then "required" else "sufficient";
            };
          }
          # Taken from: https://wiki.nixos.org/wiki/Yubikey#Locking_the_screen_when_a_Yubikey_is_unplugged
          (lib.mkIf config.yubi.logoutOnRemoval {
            services.udev.extraRules = ''
              ACTION=="remove",\
               ENV{ID_BUS}=="usb",\
               ENV{ID_MODEL_ID}=="0407",\
               ENV{ID_VENDOR_ID}=="1050",\
               ENV{ID_VENDOR}=="Yubico",\
               RUN+="${lib.getExe' pkgs.systemd "loginctl"} lock-sessions"
            '';
          })
        ];
      };

    homeManager = {
      services.yubikey-agent.enable = true;
    };
  };
}
