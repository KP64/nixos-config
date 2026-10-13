{ self, inputs, ... }: {
  flake-file.inputs.sops-nix = {
    type = "github";
    owner = "Mic92";
    repo = "sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.default = {
    nixos = { config, lib, ... }: {
      imports = [ inputs.sops-nix.nixosModules.default ];

      # NOTE: Generate keys no matter if openssh is enabled or not
      #         -> Needed for Sops-Nix
      services.openssh.generateHostKeys = true;

      sops = {
        defaultSopsFile =
          let
            path = "${self}/modules/hosts/${config.networking.hostName}/secrets.yaml";
          in
          lib.mkIf (builtins.pathExists path) path;
        secrets.root_password = {
          neededForUsers = true;
          key = "password";
          sopsFile = "${self}/secrets/root-password.yaml";
        };
      };
      users.users.root.hashedPasswordFile = config.sops.secrets.root_password.path;
    };

    homeManager.imports = [ inputs.sops-nix.homeModules.default ];
  };
}
