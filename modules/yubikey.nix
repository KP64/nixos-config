{
  den.aspects.yubikey = {
    nixos =
      {
        options,
        config,
        lib,
        pkgs,
        ...
      }:
      let
        normal = "normal";
        strict = "strict";
      in
      {
        options.yubi = lib.mkOption {
          default.mode = normal;
          example = {
            mode = strict;
            lockOnRemoval = false;
          };
          type = lib.types.submodule (submod: {
            options = {
              mode = lib.mkOption {
                default = normal;
                type = lib.types.enum [
                  normal
                  strict
                ];
                example = strict;
                description = "The mode determines predefined values of yubikey rules";
              };
              lockOnRemoval = lib.mkOption {
                default = submod.config.mode == strict;
                type = lib.types.bool;
                example = false;
                description = "Whether to lock the session on yubikey removal";
              };
              mappings = lib.mkOption {
                default = { };
                type = with lib.types; attrsOf (nonEmptyListOf nonEmptyStr);
                example = {
                  kg = [
                    ":RZgKw7D6wIsCJxDZi0Nzhq06+lq+/WxbtxSziVpwsUHlePCvvoivUqXMB2QHGVmxvPFzUSxOinNakd5Bxa/I2w==,y5bw+xpm49Fb012rbCO6k9hlzcsLvzA0FKjqX68dxizYIHFw/gJavZnT9SPA5jauuyPsOEE2iMYeZ9KiQe6L4g==,es256,+presence"
                  ];
                };
                description = "See `security.pam.u2f.settings.authfile` option description";
              };
            };
          });
        };

        config = lib.mkMerge [
          {
            programs.yubikey-manager.enable = true;
            services.yubikey-agent.enable = true;
            security.pam.u2f = {
              enable = true;
              control =
                {
                  ${normal} = options.security.pam.u2f.control.default;
                  ${strict} = "required";
                }
                .${config.yubi.mode};
              settings = {
                cue = true;
                cue_prompt = "Touch security key to continue";
                origin = "pam://nixos-yubi";
                authfile =
                  lib.mkIf (config.yubi.mappings != { })
                  <| pkgs.writeText "u2f-mappings"
                  <| lib.concatLines
                  <| lib.mapAttrsToList (n: v: n + lib.concatStrings v)
                  <| config.yubi.mappings;
              };
            };
          }
          # Taken from: https://wiki.nixos.org/wiki/Yubikey#Locking_the_screen_when_a_Yubikey_is_unplugged
          (lib.mkIf config.yubi.lockOnRemoval {
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

    homeManager =
      {
        osConfig ? null,
        config,
        pkgs,
        ...
      }:
      {
        programs.gpg = {
          enable = true;
          publicKeys = [ ];
          mutableKeys = false;
          mutableTrust = false;
          scdaemonSettings.disable-ccid = osConfig.services.pcscd.enable or false;
        };
        services.gpg-agent = {
          enable = true;
          enableScDaemon = !config.programs.gpg.scdaemonSettings.disable-ccid;
          pinentry = {
            package = pkgs.pinentry-all;
            program = "pinentry-curses";
          };
        };
      };
  };
}
