{ moduleWithSystem, ... }:
{
  flake.aspects.users-kg-shells.homeManager = moduleWithSystem (
    { config, ... }:
    { lib, pkgs, ... }:
    {
      programs = {
        carapace.enable = true;

        bash.enable = true;

        nushell = {
          enable = true;

          plugins =
            (with config.packages; [
              nu_plugin_port_extension
              nu_plugin_regex
            ])
            ++ (with pkgs.nushellPlugins; [
              desktop_notifications
              formats
              hcl
              gstat
              polars
              query
              semver
              skim
            ]);

          settings = {
            show_banner = false;
            edit_mode = "vi";
          };

          configFile.text =
            let
              nuScriptsDir = builtins.path { path = pkgs.nu_scripts + /share/nu_scripts; };
            in
            lib.concatLines
            <| map (cmd: "use ${nuScriptsDir}/aliases/${cmd}/${cmd}-aliases.nu *")
            <| [
              "bat"
              "git"
            ];
        };
      };
    }
  );
}
