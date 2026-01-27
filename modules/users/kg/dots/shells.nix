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
              nu_plugin_desktop_notifications
              nu_plugin_dns
              nu_plugin_emoji
              nu_plugin_hcl
              nu_plugin_image
              nu_plugin_port_extension
              nu_plugin_regex
              nu_plugin_semver
              nu_plugin_skim
            ])
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
