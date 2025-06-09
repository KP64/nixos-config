{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.cli.starship;
  basePath = "${inputs.starship}/docs/public/presets/toml";

  presets =
    basePath |> lib.filesystem.listFilesRecursive |> map baseNameOf |> map (lib.removeSuffix ".toml");
in
{
  options.cli.starship = {
    enable = lib.mkEnableOption "Starship";

    preset = lib.mkOption {
      default = "bracketed-segments";
      type = lib.types.enum presets;
      example = "nerd-font-symbols";
      description = ''
        The preset to be applied is found at
        https://github.com/starship/starship/tree/master/docs/public/presets/toml
      '';
    };
  };

  config.programs.starship = {
    inherit (cfg) enable;
    settings = lib.importTOML "${basePath}/${cfg.preset}.toml";
  };
}
