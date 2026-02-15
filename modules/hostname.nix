{
  flake.aspects.hostname.homeManager =
    { config, lib, ... }:
    {
      options.hostname = lib.mkOption {
        readOnly = true;
        type = with lib.types; nullOr nonEmptyStr;
        example = "sindbad";
        description = "The Name of the host managing this home-manager instance";
      };

      config.assertions = lib.singleton {
        assertion = config.hostname != null;
        message = "The hostname of the Home-Manager host is missing";
      };
    };
}
