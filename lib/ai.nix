{ lib }:
{
  /**
    Generates a list of a model with different parameter counts.

    # Example

    ```nix
    genModelTypes "qwen3" [ "0.6" 4 8 ]
    =>
    [ "qwen3:0.6b" "qwen3:4b" "qwen3:8b" ]
    ```

    # Type

    ```
    genModelTypes :: String -> [ a ] -> [ String ]
    ```

    # Arguments

    modelName
    : The name of the model

    parameters
    : The list of parameters
  */
  genModelTypes =
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
}
