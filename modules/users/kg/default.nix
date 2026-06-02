toplevel@{ den, inputs, ... }:
{
  den.aspects.kg = { host, ... }: {
    includes =
      (with den.batteries; [
        primary-user
        (user-shell "bash")
      ])
      ++ (with den.aspects; [
        catppuccin
        ssh
        vcs
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

      users.users.kg = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.kg_password.path;
        description = with config.home-manager.users.kg.invisible; "${firstName} ${lastName}";
        openssh.authorizedKeys.keyFiles =
          map (key: ./keys/${key}) <| builtins.attrNames <| builtins.readDir ./keys;
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
              ])
              (
                with pkgs;
                [
                  bluetui
                  caligula
                  manga-tui
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
          trippy = {
            enable = true;
            settings = {
              dns.dns-resolve-all = true;
              strategy = {
                addr-family = "ipv6-then-ipv4";
                icmp-extensions = true;
              };
              trippy.log-span-events = "full";
              tui = {
                tui-address-mode = "both";
                tui-as-mode = "asn";
                tui-custom-columns = "holsravbwdt";
                tui-icmp-extension-mode = "all";
              };
            };
          };
        };
      };
  };
}
