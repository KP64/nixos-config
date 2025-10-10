{
  flake.modules.homeManager.shells =
    { lib, pkgs, ... }:
    {
      programs = {
        bash.enable = true;

        nushell = {
          enable = true;

          plugins = with pkgs.nushellPlugins; [
            desktop_notifications
            formats
            gstat
            hcl
            highlight
            query
            semver
            skim
          ];

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
    };
}
