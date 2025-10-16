{
  flake.modules.homeManager.shells =
    { lib, pkgs, ... }:
    {
      programs = {
        carapace.enable = true;

        bash.enable = true;

        nushell = {
          enable = true;

          plugins = with pkgs.nushellPlugins; [
            formats
            gstat
            hcl
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
