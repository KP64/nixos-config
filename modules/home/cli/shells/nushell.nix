{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.cli.shells.nushell;
in
{
  options.cli.shells.nushell.enable = lib.mkEnableOption "Nushell";

  config.programs.nushell = {
    inherit (cfg) enable;
    plugins = with pkgs.nushellPlugins; [
      formats
      gstat
      polars
      query
    ];
    settings.show_banner = false;
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
          "zoxide"
        ]}
      '';
  };
}
