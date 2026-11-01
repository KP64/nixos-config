{ den, lib, ... }:
let
  user = "kg";
in
{
  den.aspects.${user} = { host, ... }: {
    includes =
      (with den; [
        (batteries.unfree [
          "cccl"
          "cuda_crt"
          "cuda_cudart"
          "cuda_nvcc"
          "cuda_nvrtc"
          "cudnn"
          "libcublas"
          "libcufft"
          "libcurand"
          "libcusparse"
          "libnpp"
          "libnvjitlink"
          "libnvvm"
        ])
        aspects.catppuccin
      ])
      ++ (with den.aspects.gaming._; [
        steam
        lutris
      ]);

    yubikeys = [
      # Type A
      {
        name = "YubiKey OTP+FIDO+CCID";
        hash = "2msOvGX5iCToX2LqCqPIO9H6KxlnnkuQgfKCOZkGzNg=";
        vendorID = "1050";
        modelID = "0407";
        mapping = ":RZgKw7D6wIsCJxDZi0Nzhq06+lq+/WxbtxSziVpwsUHlePCvvoivUqXMB2QHGVmxvPFzUSxOinNakd5Bxa/I2w==,y5bw+xpm49Fb012rbCO6k9hlzcsLvzA0FKjqX68dxizYIHFw/gJavZnT9SPA5jauuyPsOEE2iMYeZ9KiQe6L4g==,es256,+presence";
        interfaces = [
          "03:01:01"
          "03:00:00"
          "0b:00:00"
        ];
      }
      # Type C
      {
        name = "YubiKey OTP+FIDO+CCID";
        hash = "Q+A8QQReKclmBSaDIYja0w4Bx6ld2IU6wF7HFKdtJ3Q=";
        vendorID = "1050";
        modelID = "0407";
        mapping = ":yVHdK9qjRwBI0ljQpJNdsDSlAKatmvMFiB5H5RaWjgebzGEiTEp5dDtOk2EqnxWB48uL0F1sQAXwd/mHO9Syyw==,6FxqcIXEjnh/KA6Bjy5BhrFl8jMnsLpJ+Ph0s1XhuyQ0FJXewL3l0b0EXQ7DudMsAy7Vy0pRatsG3+AdGmMnjw==,es256,+presence";
        interfaces = [
          "03:01:01"
          "03:00:00"
          "0b:00:00"
        ];
      }
    ];

    provides.to-hosts.nixos =
      { host, ... }:
      lib.optionalAttrs host.isDesktop {
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
        extraGroups = map (group: group.name) (
          with config.users.groups;
          [
            input
            video
          ]
        );
      };
    };

    homeManager = { pkgs, ... }: {
      home = {
        shellAliases.c = "clear";
        keyboard = {
          layout = "de";
          options = [ "caps:escape" ];
        };
        packages =
          (with pkgs; [
            igrep
            systemctl-tui
          ])
          ++ (lib.optionals host.isDesktop (
            with pkgs;
            [
              bluetui
              caligula
              manga-tui
              nyancat
              signal-desktop
              yubioath-flutter
            ]
          ));
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
