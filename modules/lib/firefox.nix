{
  flake.aspects.customLib.homeManager =
    { lib, ... }:
    {
      nix-lib.lib.firefox = {
        hideEngines = {
          type = with lib.types; functionTo <| attrsOf anything;
          fn =
            list:
            lib.genAttrs list (_: {
              metaData.hidden = true;
            });
          description = ''
            Takes in a list of search engines to disable
          '';
        };
      };
    };
}
