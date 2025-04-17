{ config, lib, ... }:
let
  inherit (config.system) language;
in
{
  options.system.language = lib.mkOption {
    default = "de";
    type = lib.types.nonEmptyStr;
    description = "Sets language and keyMap";
    example = "en";
  };

  config =
    let
      lang =
        if (language == "en") then
          "en_US.UTF-8"
        else if (language == "de") then
          "de_DE.UTF-8"
        else
          throw "Seems like your language hasn't been added. Open up an Issue or open a PR yourself!";
    in
    {
      console.keyMap = language;

      services.xserver.xkb.layout = language;

      i18n.extraLocaleSettings = {
        LC_ADDRESS = lang;
        LC_IDENTIFICATION = lang;
        LC_MEASUREMENT = lang;
        LC_MONETARY = lang;
        LC_NAME = lang;
        LC_NUMERIC = lang;
        LC_PAPER = lang;
        LC_TELEPHONE = lang;
        LC_TIME = lang;
      };
    };
}
