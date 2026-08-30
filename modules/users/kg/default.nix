toplevel@{ den, inputs, ... }:
let
  user = "kg";
  nix.settings.trusted-users = [ user ];
in
{
  den.aspects.${user} = { host, ... }: {
    includes =
      (with den.batteries; [
        primary-user
        (user-shell "bash")
      ])
      ++ (with den.aspects; [
        catppuccin
        ssh
        vcs._.git
        vcs._.jujutsu
        yubikey
      ])
      ++ (with den.aspects.${user}._; [
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
      inherit nix;

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

      yubi.mappings.${user} = [
        # 5 Type A
        ":RZgKw7D6wIsCJxDZi0Nzhq06+lq+/WxbtxSziVpwsUHlePCvvoivUqXMB2QHGVmxvPFzUSxOinNakd5Bxa/I2w==,y5bw+xpm49Fb012rbCO6k9hlzcsLvzA0FKjqX68dxizYIHFw/gJavZnT9SPA5jauuyPsOEE2iMYeZ9KiQe6L4g==,es256,+presence"
        # 5 Type C
        ":yVHdK9qjRwBI0ljQpJNdsDSlAKatmvMFiB5H5RaWjgebzGEiTEp5dDtOk2EqnxWB48uL0F1sQAXwd/mHO9Syyw==,6FxqcIXEjnh/KA6Bjy5BhrFl8jMnsLpJ+Ph0s1XhuyQ0FJXewL3l0b0EXQ7DudMsAy7Vy0pRatsG3+AdGmMnjw==,es256,+presence"
      ];

      users.users.${user} = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets."${user}_password".path;
        description = with config.home-manager.users.${user}.invisible; "${firstName} ${lastName}";
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
        osConfig ? null,
        config,
        lib,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.nix-invisible.modules.homeManager."user-${user}" ];

        nix = lib.mkIf (osConfig == null) nix;

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
