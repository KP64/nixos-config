{ inputs, den, ... }: {
  flake-file.inputs.disko = {
    type = "github";
    owner = "nix-community";
    repo = "disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [ inputs.disko.flakeModules.default ];

  den = {
    classes.disko.description = "Forward Disko to nixos hosts and create standalone diskoConfigurations";
    schema.host.includes = [ den.policies.disko-to-host ];
    policies.disko-to-host =
      let
        inherit (den.lib) policy;
      in
      _: [
        (policy.include { nixos.imports = [ inputs.disko.nixosModules.default ]; })
        (policy.route {
          fromClass = "disko";
          intoClass = "nixos";
          path = [ "disko" ];
        })
      ];
  };
}
