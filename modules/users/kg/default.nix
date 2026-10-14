toplevel@{ den, ... }:
let
  user = "kg";
in
{
  den.aspects.${user} = { host, lib, ... }: {
    includes = [
      den.aspects.catppuccin
    ]
    ++ (with den.aspects.gaming._; [
      steam
      lutris
    ]);

    # TODO: Solidify yubikeys into a god struct that spans across aspects?
    #         -> IDs, name, hash and interfaces would allow for dynamic udev and USBGuard rules.
    # TODO: Check this works as intended.
    additionalUSBGuardRules = [
      # Yubikey 5 Type A
      ''allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "2msOvGX5iCToX2LqCqPIO9H6KxlnnkuQgfKCOZkGzNg=" with-interface equals { 03:01:01 03:00:00 0b:00:00 } with-connect-type "hotplug"''
      # Yubikey 5 Type C
      ''allow id 1050:0407 serial "" name "YubiKey OTP+FIDO+CCID" hash "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=" with-interface equals { 03:01:01 03:00:00 0b:00:00 } with-connect-type "hotplug"''
    ];

    yubikeyMappings.${user} = [
      # 5 Type A
      ":RZgKw7D6wIsCJxDZi0Nzhq06+lq+/WxbtxSziVpwsUHlePCvvoivUqXMB2QHGVmxvPFzUSxOinNakd5Bxa/I2w==,y5bw+xpm49Fb012rbCO6k9hlzcsLvzA0FKjqX68dxizYIHFw/gJavZnT9SPA5jauuyPsOEE2iMYeZ9KiQe6L4g==,es256,+presence"
      # 5 Type C
      ":yVHdK9qjRwBI0ljQpJNdsDSlAKatmvMFiB5H5RaWjgebzGEiTEp5dDtOk2EqnxWB48uL0F1sQAXwd/mHO9Syyw==,6FxqcIXEjnh/KA6Bjy5BhrFl8jMnsLpJ+Ph0s1XhuyQ0FJXewL3l0b0EXQ7DudMsAy7Vy0pRatsG3+AdGmMnjw==,es256,+presence"
    ];

    # WARNING: Using "_" doesn't work here. Seems like a bug
    # TODO: Open an Issue in den
    provides.to-hosts.nixos =
      { host, ... }:
      toplevel.lib.optionalAttrs host.isDesktop {
        programs = {
          ausweisapp = {
            enable = true;
            openFirewall = true;
          };
          localsend = {
            enable = true;
            openFirewall = true;
          };
          thunar.enable = true;
        };
      };

    nixos = { config, ... }: {
      sops.secrets =
        let
          sopsFile = ./secrets.yaml;
        in
        {
          "${user}_password" = {
            neededForUsers = true;
            key = "password";
            inherit sopsFile;
          };
          "anki/${user}" = {
            key = "anki/password";
            inherit sopsFile;
          };
        };

      users.users.${user} = {
        hashedPasswordFile = config.sops.secrets."${user}_password".path;
        openssh.authorizedKeys.keyFiles = lib.fileset.toList ./keys;
        # TODO: Move to relevant aspects
        extraGroups =
          (map (group: group.name) (
            with config.users.groups;
            [
              input
              video
            ]
          ))
          ++ lib.optional config.hardware.i2c.enable config.hardware.i2c.group;
      };
    };

    homeManager = { config, pkgs, ... }: {
      home = {
        shellAliases.c = "clear";
        packages =
          (with pkgs; [
            igrep
            systemctl-tui
          ])
          # TODO: Replace with host capabilities
          ++ (lib.optionals
            (builtins.elem host.name [
              toplevel.config.flake.nixosConfigurations.aladdin.config.networking.hostName
              "sindbad"
            ])
            (
              with pkgs;
              [
                bluetui
                caligula
                manga-tui
                nyancat
                signal-desktop
                yubioath-flutter
              ]
            )
          );
      };

      sops = {
        defaultSopsFile = ./secrets.yaml;
        age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
      };

      services.pueue.enable = true;

      programs = {
        bat.enable = true;
        bottom.enable = true;
        btop = {
          enable = true;
          settings = {
            vim_keys = true;
            update_ms = 1000;
          };
        };
        cava.enable = true;
        fastfetch.enable = true;
        less.enable = true;
        pay-respects.enable = true;
        ripgrep.enable = true;
        skim.enable = true;
      };
    };
  };
}
