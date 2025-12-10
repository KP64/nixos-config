toplevel: {
  flake.modules.homeManager.users-kg-anki =
    { config, ... }:
    {
      sops.secrets = {
        "anki/username" = { };
        "anki/sync_key" = { };
      };

      programs.anki = {
        enable = true;
        style = "anki";
        theme = "dark";
        sync =
          let
            inherit (config.sops) secrets;
          in
          {
            autoSync = true;
            syncMedia = true;
            url = "https://anki.${toplevel.config.flake.nixosConfigurations.mahdi.config.networking.domain}";
            usernameFile = secrets."anki/username".path;
            keyFile = secrets."anki/sync_key".path;
          };
      };
    };
}
