{ moduleWithSystem, ... }:
{
  flake.modules.homeManager.users-kg-shells = moduleWithSystem (
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
              nu_plugin_compress
              nu_plugin_dns
              nu_plugin_emoji
              nu_plugin_port_extension
            ])
            ++ (with pkgs.nushellPlugins; [
              desktop_notifications
              formats
              gstat
              hcl
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
