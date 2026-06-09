{
  den.aspects.kg._.shells.homeManager = { lib, pkgs, ... }: {
    programs = {
      carapace.enable = true;

      nushell = {
        enable = true;

        plugins = with pkgs.nushellPlugins; [
          formats
          gstat
          polars
          query
        ];

        settings = {
          show_banner = false;
          edit_mode = "vi";
        };

        extraConfig =
          lib.concatLines
          <|
            map
              (
                cmd:
                "use ${
                  builtins.path { path = "${pkgs.nu_scripts}/share/nu_scripts/aliases/${cmd}/${cmd}-aliases.nu"; }
                } *"
              )
              [
                "bat"
                "git"
              ];
      };
    };
  };
}
