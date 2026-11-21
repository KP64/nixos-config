toplevel@{ lib, ... }:
{
  den = {
    schema.host.options.isConfigBuilder = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = "Whether the machine is powerful enough to build the whole config";
    };

    default.nixos = { host, config, ... }: {
      boot.binfmt.emulatedSystems =
        let
          getArch = config: config.nixpkgs.hostPlatform.system;
          currentArch = getArch config;
        in
        toplevel.config.flake.nixosConfigurations
        |> builtins.attrValues
        |> map (machine: getArch machine.config)
        |> builtins.filter (arch: arch != currentArch)
        |> lib.unique
        |> lib.optionals host.isConfigBuilder;
    };
  };
}
