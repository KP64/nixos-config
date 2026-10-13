{
  den.aspects.kg.homeManager =
    {
      host,
      config,
      lib,
      ...
    }:
    lib.optionalAttrs host.isGraphical {
      sops.secrets = {
        "anki/username" = { };
        "anki/sync_key" = { };
      };

      programs.anki = {
        enable = true;
        style = "anki";
        theme = "dark";
        profiles.${config.home.username} = {
          default = true;
          sync =
            let
              inherit (config.sops) secrets;
            in
            {
              autoSync = true;
              syncMedia = true;
              # TODO: Replace
              url = "https://anki.srvd.space";
              usernameFile = secrets."anki/username".path;
              keyFile = secrets."anki/sync_key".path;
            };
        };
      };
    };
}
