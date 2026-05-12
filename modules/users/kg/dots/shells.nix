{ moduleWithSystem, ... }:
{
  den.aspects.kg._.shells.homeManager = moduleWithSystem (
    { config, ... }:
    { lib, pkgs, ... }:
    {
      programs = {
        carapace.enable = true;

        bash.enable = true;

        nushell = {
          enable = true;

          plugins = [
            config.packages.nu_plugin_port_extension
          ]
          ++ (with pkgs.nushellPlugins; [
            formats
            gstat
            polars
            query
          ]);

          settings = {
            show_banner = false;
            edit_mode = "vi";
          };

          extraConfig =
            let
              nuScriptsDir = builtins.path { path = "${pkgs.nu_scripts}/share/nu_scripts"; };
            in
            lib.concatLines
            <| map (cmd: "use ${nuScriptsDir}/aliases/${cmd}/${cmd}-aliases.nu *") [
              "bat"
              "git"
            ];
        };
      };
    }
  );
}
