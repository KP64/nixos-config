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
            units
          ];

          settings.show_banner = false;

          # TODO: Check that configFile works as expected
          # If doesn't work -> Use extraConfig
          configFile.text =
            let
              nuScriptsDir = "${pkgs.nu_scripts}/share/nu_scripts";
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
