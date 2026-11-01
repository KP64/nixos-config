{ den, ... }: {
  den = {
    quirks = {
      yubikeys.description = "User's yubikeys";
      u2fmappings.description = "User U2F Mappings";
    };

    policies.map-yubis-to-u2f =
      { host, ... }:
      let
        currentHost = host.name;
        inherit (den.lib.policy) pipe;
      in
      [
        (pipe.from "yubikeys" [
          (pipe.collectAll ({ user, host, ... }: host.name == currentHost && user != null))
          pipe.withProvenance
          (pipe.as "u2fmappings")
        ])
      ];

    schema.host.includes = [ den.policies.map-yubis-to-u2f ];

    default.includes = [ den.aspects.yubikey ];
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
          config,
          pkgs,
          u2fmappings,
          ...
        }:
        let
          grouped = lib.groupBy (entry: entry.source.user.name) u2fmappings;

          mappings = lib.mapAttrsToList (
            username: entries: username + lib.concatMapStrings (entry: entry.value.mapping) entries
          ) grouped;
        in
        lib.mkMerge [
          {
            security.pam.u2f = {
              enable = mappings != [ ];
              settings = {
                cue = true;
                control = "required";
                cue_prompt = "Touch security key to continue";
                origin = "pam://nixos-yubi";
                authfile =
                  lib.mkIf config.security.pam.u2f.enable
                  <| pkgs.writeText "u2f-mappings"
                  <| lib.concatLines
                  <| mappings;
              };
            };
          }
          (lib.mkIf config.security.pam.u2f.enable {
            programs.yubikey-manager.enable = true;
            services = {
              yubikey-agent.enable = true;
              # Taken from: https://wiki.nixos.org/wiki/Yubikey#Locking_the_screen_when_a_Yubikey_is_unplugged
              udev.extraRules =
                let
                  mkRule = { modelID, vendorID }: ''
                    ACTION=="remove",\
                     ENV{ID_BUS}=="usb",\
                     ENV{ID_MODEL_ID}=="${modelID}",\
                     ENV{ID_VENDOR_ID}=="${vendorID}",\
                     ENV{ID_VENDOR}=="Yubico",\
                     RUN+="${lib.getExe' pkgs.systemd "loginctl"} lock-sessions"
                  '';

                  rules =
                    u2fmappings
                    |> map (m: mkRule { inherit (m.value) modelID vendorID; })
                    |> lib.unique
                    |> lib.concatLines;
                in
                lib.mkIf host.settings.yubikey.lockOnRemoval rules;
            };
          })
        ];
    };
  };
}
