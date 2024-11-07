{
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  plugins = with pkgs.nushellPlugins; [ gstat ];

  activateNuPluginsScript = pkgs.writers.writeNu "activateNuPlugins" (
    lib.concatLines (
      map (
        plugin:
        let
          plugin_name = builtins.replaceStrings [ "nushell" ] [ "nu" ] (lib.getName plugin);
        in
        "plugin add ${plugin}/bin/${plugin_name}"
      ) plugins
    )
  );

  msgPackz = pkgs.runCommand "nushellMsgPackz" { } ''
    mkdir -p "$out"
    ${pkgs.nushell}/bin/nu --plugin-config "$out/plugin.msgpackz" ${activateNuPluginsScript}
  '';
in
{

  options.cli.shells.nushell.enable = lib.mkEnableOption "Enable nushell";

  config = lib.mkIf config.cli.shells.nushell.enable {
    environment.persistence."/persist".users.${username}.files = [ ".config/nushell/history.txt" ];
    home-manager.users.${username} = {
      xdg.configFile."nushell/plugin.msgpackz".source = "${msgPackz}/plugin.msgpackz";
      programs.nushell = {
        enable = true;
        shellAliases = {
          ll = "ls -l";
          la = "ls -a";
          lla = "ls -l -a";
        };
        configFile.text = # nu
          ''
            $env.config = {
              show_banner: false
            }
          '';
        extraEnv = # nu
          ''
            def --env yy [...args] {
            	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
            	yazi ...$args --cwd-file $tmp
            	let cwd = (open $tmp)
            	if $cwd != "" and $cwd != $env.PWD {
            		cd $cwd
              }
              rm -fp $tmp
            }
          '';
      };
    };
  };
}
