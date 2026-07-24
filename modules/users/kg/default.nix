toplevel@{ den, inputs, ... }:
{
  den.aspects.kg = { host, ... }: {
    includes =
      (with den.batteries; [
        primary-user
        (user-shell "bash")
        (unfree [ "PlantsVsZombiesSetup.exe" ])
      ])
      ++ (with den.aspects; [
        catppuccin
        ssh
        trippy
        vcs._.git
        vcs._.jujutsu
        yubikey
      ])
      ++ (with den.aspects.kg._; [
        atuin
        delta
        fd
        neovim
        shells
        starship
        tealdeer
        yazi
        zellij
        zoxide
      ]);

    nixos = { config, lib, ... }: {
      sops.secrets =
        let
          sopsFile = ./secrets.yaml;
        in
        {
          kg_password = {
            neededForUsers = true;
            key = "password";
            inherit sopsFile;
          };
          "anki/kg" = {
            key = "anki/password";
            inherit sopsFile;
          };
        };

      yubi.mappings.kg = [
        # 5 Type A
        ":RZgKw7D6wIsCJxDZi0Nzhq06+lq+/WxbtxSziVpwsUHlePCvvoivUqXMB2QHGVmxvPFzUSxOinNakd5Bxa/I2w==,y5bw+xpm49Fb012rbCO6k9hlzcsLvzA0FKjqX68dxizYIHFw/gJavZnT9SPA5jauuyPsOEE2iMYeZ9KiQe6L4g==,es256,+presence"
        # 5 Type C
        ":yVHdK9qjRwBI0ljQpJNdsDSlAKatmvMFiB5H5RaWjgebzGEiTEp5dDtOk2EqnxWB48uL0F1sQAXwd/mHO9Syyw==,6FxqcIXEjnh/KA6Bjy5BhrFl8jMnsLpJ+Ph0s1XhuyQ0FJXewL3l0b0EXQ7DudMsAy7Vy0pRatsG3+AdGmMnjw==,es256,+presence"
      ];

      users.users.kg = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.kg_password.path;
        description = with config.home-manager.users.kg.invisible; "${firstName} ${lastName}";
        openssh.authorizedKeys.keyFiles = lib.fileset.toList ./keys;
        extraGroups =
          (map (group: group.name) (
            with config.users.groups;
            [
              input
              audio
              video
            ]
          ))
          ++ lib.optional config.services.tcsd.enable config.services.tcsd.group
          ++ lib.optional config.hardware.i2c.enable config.hardware.i2c.group;
      };
    };

    homeManager =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.nix-invisible.modules.homeManager.user-kg ];

        vcs.user = {
          name = "KP64";
          inherit (config.invisible) email;
        };

        home = {
          shellAliases.c = "clear";
          packages =
            (with pkgs; [
              igrep
              systemctl-tui
            ])
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
                  gnome-obfuscate
                  manga-tui
                  nyancat
                  signal-desktop
                  switcheroo
                  yubioath-flutter
                  pvz-portable
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
          btop.enable = true;
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
