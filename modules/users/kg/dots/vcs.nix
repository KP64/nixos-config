{
  den.aspects.kg.homeManager =
    { user, config, ... }:
    let
      usr = {
        name = "KP64";
        inherit (user) email;
      };
      sshDir = "${config.home.homeDirectory}/.ssh";
      allowedSignersFile = "${sshDir}/allowed_signers";
      signingKey = "${sshDir}/id_ed25519.pub";
    in
    {
      programs = {
        git-cliff.enable = true;
        gitui.enable = true;
        git = {
          enable = true;
          lfs.enable = true;
          settings = {
            user = usr;
            init.defaultBranch = "main";
            gpg.ssh = { inherit allowedSignersFile; };
          };
          signing = {
            signByDefault = true;
            format = "ssh";
            key = signingKey;
          };
        };
      };

      programs = {
        jjui.enable = true;
        jujutsu = {
          enable = true;
          settings = {
            user = usr;
            ui.default-command = [ "log" ];
            signing = {
              behavior = "own";
              backend = "ssh";
              key = signingKey;
              backends.ssh.allowed-signers = allowedSignersFile;
            };
          };
        };
      };
    };
}
