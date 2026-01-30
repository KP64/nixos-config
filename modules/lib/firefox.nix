{ lib, ... }:
{
  nlib.lib = {
    hideEngines = {
      type = with lib.types; functionTo attrs;
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
}
