{
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  plugins = with pkgs.nushellPlugins; [
    dbus
    formats
    gstat
    skim
  ];

  activateNuPluginsScript =
    plugins
    |> (map (
      plugin:
      let
        plugin_name = builtins.replaceStrings [ "nushell" ] [ "nu" ] (lib.getName plugin);
      in
      "plugin add ${plugin}/bin/${plugin_name}"
    ))
    |> lib.concatLines
    |> pkgs.writers.writeNu "activateNuPlugins";

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
        configFile.source = ./config.nu;
        extraConfig =
          let
            nuScriptsDir = "${pkgs.nu_scripts}/share/nu_scripts";

            useAlias = cmd: "use ${nuScriptsDir}/aliases/${cmd}/${cmd}-aliases.nu *";

            completionsDir = "${nuScriptsDir}/custom-completions";
            useCompletion =
              cmd:
              if builtins.isAttrs cmd then
                "use ${completionsDir}/${cmd.dir}/${cmd.file}-completions.nu *"
              else
                "use ${completionsDir}/${cmd}/${cmd}-completions.nu *";
          in
          ''
            # Theme
            source ${nuScriptsDir}/themes/nu-themes/catppuccin-mocha.nu

            # Aliases
            ${lib.concatMapStringsSep "\n" useAlias [
              "bat"
              "docker"
              "git"
            ]}

            # Completions
            ${lib.concatMapStringsSep "\n" useCompletion [
              "ani-cli"
              "bat"
              "cargo"
              "curl"
              "docker"
              "git"
              "glow"
              "just"
              "less"
              "make"
              "man"
              "nix"
              "npm"
              "rg"
              "rustup"
              "ssh"
              "tar"
              {
                dir = "tealdeer";
                file = "tldr";
              }
              "typst"
              "zellij"
            ]}
          '';
      };
    };
  };
}
