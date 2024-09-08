{
  lib,
  config,
  username,
  ...
}:
{

  options.cli.shells.nushell.enable = lib.mkEnableOption "Enable nushell";

  config = lib.mkIf config.cli.shells.nushell.enable {
    home-manager.users.${username}.programs.nushell = {
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
}
