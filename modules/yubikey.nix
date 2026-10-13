{ den, ... }: {
  den = {
    quirks.yubikeyMappings.description = "User yubikey U2F mappings";
    policies.expose-yubikey-mappings = _: [
      (den.lib.policy.pipe.from "yubikeyMappings" [ den.lib.policy.pipe.expose ])
    ];
    schema.user.includes = [ den.policies.expose-yubikey-mappings ];

    aspects.yubikey = { lib, ... }: {
      settings.lockOnRemoval = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = "Whether to lock the session on yubikey removal";
      };

      nixos =
        {
          host,
          pkgs,
          yubikeyMappings,
          ...
        }:
        let
          mappings = lib.mergeAttrsList yubikeyMappings;
        in
        lib.mkMerge [
          {
            programs.yubikey-manager.enable = true;
            services.yubikey-agent.enable = true;
            security.pam.u2f = {
              enable = true;
              control = "required";
              settings = {
                cue = true;
                cue_prompt = "Touch security key to continue";
                origin = "pam://nixos-yubi";
                authfile =
                  lib.mkIf (mappings != { })
                  <| pkgs.writeText "u2f-mappings"
                  <| lib.concatLines
                  <| lib.mapAttrsToList (n: v: n + lib.concatStrings v)
                  <| mappings;
              };
            };
          }
          # Taken from: https://wiki.nixos.org/wiki/Yubikey#Locking_the_screen_when_a_Yubikey_is_unplugged
          (lib.mkIf host.settings.yubikey.lockOnRemoval {
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

      homeManager =
        {
          nixosConfig ? null,
          ...
        }:
        let
          disableCCID = nixosConfig.services.pcscd.enable or false;
        in
        {
          programs.gpg.scdaemonSettings = lib.mkIf disableCCID { disable-ccid = true; };
          services.gpg-agent.enableScDaemon = !disableCCID;
        };
    };
  };
}
