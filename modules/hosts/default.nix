toplevel: {
  perSystem.checks = builtins.mapAttrs (
    _: v: v.config.system.build.toplevel
  ) toplevel.config.flake.nixosConfigurations;
}
