{
  lib,
  config,
  pkgs,
  username,
  ...
}:

let
  cfg = config.cli.git;
  aliases = {
    cl = "clone";
    i = "init";

    a = "add";
    mv = "mv";
    r = "restore";
    rm = "rm";

    bi = "bisect";
    d = "diff";
    g = "grep";
    l = "log";
    sh = "show";
    s = "status";

    b = "branch";
    c = "commit";
    m = "merge";
    rb = "rebase";
    rs = "reset";
    sw = "switch";
    t = "tag";

    f = "fetch";
    p = "push";
    pl = "pull";
  };
in
{
  options.cli.git = with lib; {
    enable = mkEnableOption "Enables Git & helper Utils";
    user = {
      name = mkOption {
        description = "Your Git Username";
        type = types.str;
        readOnly = true;
      };
      email = mkOption {
        description = "Your Git Email";
        type = types.str;
        readOnly = true;
      };
    };
  };

  config =
    let
      # 'home.shellAliases' claims it works for every shell.
      # However it only works for bash, zsh & fish.
      # Nushell & ion aren't included.
      # TODO: Research why & maybe open Issue
      shellAliases = lib.mapAttrs' (name: value: lib.nameValuePair "g${name}" "git ${value}") aliases;
    in
    lib.mkIf cfg.enable {
      home-manager.users.${username} = {
        programs.nushell = {
          inherit shellAliases;
        };
        home = {
          inherit shellAliases;
          packages = with pkgs; [
            gitoxide
            gitleaks
          ];
        };

        programs = {
          gitui.enable = true;

          git-cliff.enable = true;

          jujutsu = {
            enable = true;
            settings = {
              inherit (cfg) user;
            };
          };

          git = {
            enable = true;
            lfs.enable = true;
            userName = cfg.user.name;
            userEmail = cfg.user.email;
            delta = {
              enable = true;
              options.line-numbers = true;
            };
            extraConfig.init.defaultBranch = "master";
            inherit aliases;
          };
        };
      };
    };
}
