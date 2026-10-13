{ den, ... }: {
  den.aspects.kg = {
    includes = [ (den.batteries.user-shell "bash") ];

    homeManager = { lib, pkgs, ... }: {
      programs = {
        carapace.enable = true;

        nushell = {
          enable = true;

          plugins = with pkgs.nushellPlugins; [
            formats
            gstat
            query
          ];

          settings = {
            show_banner = false;
            edit_mode = "vi";
          };

          extraConfig = lib.concatLines (
            lib.mapAttrsToList
              (
                cmd: sha256:
                "use ${
                  builtins.path {
                    name = "${cmd}-aliases.nu";
                    path = "${pkgs.nu_scripts}/share/nu_scripts/aliases/${cmd}/${cmd}-aliases.nu";
                    recursive = false;
                    inherit sha256;
                  }
                } *"
              )
              {
                "bat" = "sha256-5RGWZFjwaQvALsq68wNOMuG7YXHha+7SbhsXXCEEEzw=";
                "git" = "sha256-o7UKYLbrVrq9FLGa9+jBs2WJLi17Qrklbs37RL3d8vE=";
              }
          );
        };
      };
    };
  };
}
