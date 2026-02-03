{
  flake.modules.nixos.customLib =
    { lib, ... }:
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
      };
    };
}
