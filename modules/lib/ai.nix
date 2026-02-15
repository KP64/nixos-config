toplevel: {
  flake.modules.nixos.customLib =
    { config, lib, ... }:
    {
      nix-lib.lib.ai = {
        genModelTypes = {
          type = with lib.types; functionTo <| functionTo <| listOf nonEmptyStr;
          fn =
            modelName: parameters:
            parameters
            |> map (
              p:
              let
                modelType = "${modelName}:${toString p}";
                modelType' = "${modelType}b";
              in
              if builtins.isInt p then
                modelType'
              else if builtins.isString p then
                if (lib.hasSuffix "m" p) then modelType else modelType'
              else
                throw "Only Strings and Integer are Supported!"
            );
          description = ''
            Generates a list of a model with
            different parameter counts.
          '';
        };

        getOtherOllamaUrls = {
          type = with lib.types; listOf nonEmptyStr;
          fn =
            toplevel.config.flake.nixosConfigurations
            |> builtins.attrValues
            |> map (host: host.config)
            |> builtins.filter (nixosCfg: nixosCfg.networking.hostName != config.networking.hostName)
            |> builtins.filter (
              nixosCfg:
              nixosCfg.services.ollama.enable && nixosCfg.services.ollama.openFirewall && nixosCfg ? staticIPv4
            )
            |> map (nixosCfg: "http://${nixosCfg.staticIPv4}:${toString nixosCfg.services.ollama.port}");
          description = ''
            Return a list Ollama IPs of every host
            configured in this config except for the
            current host (localhost).
          '';
        };
      };
    };
}
