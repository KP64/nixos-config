{ config, ... }:
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = config.programs.git.userName;
        email = config.programs.git.userEmail;
      };
      signing = {
        behavior = "own";
        backend = "ssh";
        inherit (config.programs.git.signing) key;
        backends.ssh.allowed-signers = config.programs.git.extraConfig.gpg.ssh.allowedSignersFile;
      };
    };
  };
}
