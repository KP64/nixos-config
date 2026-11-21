{
  den.aspects.kg.homeManager =
    {
      host,
      config,
      lib,
      ...
    }:
    let
      usernameSecret = "anki/username";
      syncKeySecret = "anki/sync_key";
    in
    lib.optionalAttrs host.isGraphical {
      sops.secrets = {
        ${usernameSecret} = { };
        ${syncKeySecret} = { };
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
              # TODO: Re-Add
              # url = "https://anki.srvd.space";
              usernameFile = secrets.${usernameSecret}.path;
              keyFile = secrets.${syncKeySecret}.path;
            };
        };
      };
    };
}
