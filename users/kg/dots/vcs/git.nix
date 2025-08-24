{ inputs, ... }:
let
  globals = import "${inputs.nix-invisible}/globals.nix";
in
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "KP64";
    userEmail = globals.users.kg.email;
    delta = {
      enable = true;
      options.line-numbers = true;
    };
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "~/.ssh/id_ed25519.pub";
    };
    extraConfig = {
      init.defaultBranch = "main";
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
    };
  };
}
