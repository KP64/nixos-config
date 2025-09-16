toplevel@{ inputs, ... }:
{
  flake.modules = {
    nixos.users-kg =
      { config, ... }:
      {
        imports = [ inputs.nur.modules.nixos.default ];

        home-manager.users.kg.imports = [ toplevel.config.flake.modules.homeManager.users-kg ];

        sops.secrets."users/kg/password".neededForUsers = true;
        users.users.kg = {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."users/kg/password".path;
          openssh.authorizedKeys.keys = [ ];
          extraGroups = [
            "networkmanager"
            "wheel"
            "input"
            "audio"
            "video"
            "tss" # TPM
            "docker"
            "podman"
            "vboxusers"
          ];
        };
      };

    homeManager.users-kg =
      { config, ... }:
      let
        inherit (config.home) homeDirectory;
      in
      {
        imports = [
          inputs.sops-nix.homeModules.default
          ./_dots
        ]
        ++ (with toplevel.config.flake.modules.homeManager; [
          catppuccin
          fetchers
          nix
          shells
          ssh
          vcs
        ]);

        vcs.user = {
          name = "KP64";
          email = "karamalsadeh@hotmail.com";
        };

        sops = {
          defaultSopsFile = ./secrets.yaml;
          age = {
            keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
            sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
          };
          secrets = { };
        };

        home = {
          stateVersion = "25.11";
          shellAliases.c = "clear";
        };

        programs = {
          bat.enable = true;
          btop.enable = true;
          cava.enable = true;
          fzf.enable = true;
          ripgrep.enable = true;
        };
      };
  };
}
