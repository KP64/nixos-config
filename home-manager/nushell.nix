{
  programs.nushell = {
    enable = true;
    configFile.text = /*nu*/ ''
      $env.config = {
        show_banner: false
      }
    '';
    extraEnv = /*nu*/ ''
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
}
