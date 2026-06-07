toplevel: {
  den.aspects.customLib.nixos = { config, lib, ... }: {
    nix-lib.lib.ai = {
      genModelTypes = {
        type = with lib.types; functionTo <| functionTo <| listOf nonEmptyStr;
        fn =
          modelName: parameters:
          lib.forEach parameters (
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
          |> builtins.filter (
            nixosCfg:
            nixosCfg.networking.hostName != config.networking.hostName
            && nixosCfg.services.ollama.enable
            && nixosCfg.services.ollama.openFirewall
          )
          |> map (
            nixosCfg:
            let
              usesIPv6 = lib.hasInfix ":" nixosCfg.services.ollama.host;
              ip = if usesIPv6 then "[${nixosCfg.staticIPv6}]" else nixosCfg.staticIPv4;
            in
            "http://${ip}:${toString nixosCfg.services.ollama.port}"
          );
        description = ''
          Return a list Ollama IPs of every host
          configured in this config except for the
          current host (localhost).
        '';
      };
    };
  };
}
