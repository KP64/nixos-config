{
  den.aspects.kg.homeManager =
    { user, config, ... }:
    let
      usr = {
        name = "KP64";
        inherit (user) email;
      };
    in
    {
      programs = {
        git-cliff.enable = true;
        gitui.enable = true;
        git =
          let
            sshDir = "${config.home.homeDirectory}/.ssh";
          in
          {
            enable = true;
            lfs.enable = true;
            settings = {
              user = usr;
              init.defaultBranch = "main";
              gpg.ssh.allowedSignersFile = "${sshDir}/allowed_signers";
            };
            signing = {
              signByDefault = true;
              format = "ssh";
              key = "${sshDir}/id_ed25519.pub";
            };
          };
      };

      programs = {
        jjui.enable = true;
        jujutsu = {
          enable = true;
          settings =
            let
              sshDir = "${config.home.homeDirectory}/.ssh";
            in
            {
              user = usr;
              ui.default-command = [ "log" ];
              signing = {
                behavior = "own";
                backend = "ssh";
                key = "${sshDir}/id_ed25519.pub";
                backends.ssh.allowed-signers = "${sshDir}/allowed_signers";
              };
            };
        };
      };
    };
}
