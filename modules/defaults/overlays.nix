{ den, ... }: {
  den = {
    quirks.nixpkgs-overlays.description = "nixpkgs overlays collected from aspects";

    policies.project-user-overlays = _: [
      (den.lib.policy.pipe.from "nixpkgs-overlays" [ den.lib.policy.pipe.expose ])
    ];
    schema.user.includes = [ den.policies.project-user-overlays ];

    default.includes = [ den.aspects.nixpkgs-overlays ];

    aspects.nixpkgs-overlays = {
      os = { nixpkgs-overlays, lib, ... }: { nixpkgs.overlays = lib.unique nixpkgs-overlays; };
      homeManager =
        {
          osConfig ? null,
          nixpkgs-overlays,
          lib,
          ...
        }:
        lib.mkIf (osConfig == null) { nixpkgs.overlays = lib.unique nixpkgs-overlays; };
    };
  };
}
