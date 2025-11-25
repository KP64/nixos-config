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
        sync = {
          autoSync = true;
          syncMedia = true;
          url = "https://anki.${toplevel.config.flake.nixosConfigurations.mahdi.config.networking.domain}";
          usernameFile = config.sops.secrets."anki/username".path;
          keyFile = config.sops.secrets."anki/sync_key".path;
        };
      };
    };
}
