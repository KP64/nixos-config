{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  imports = with inputs; [
    catppuccin.homeModules.default
    sops-nix.homeManagerModules.default
  ];

  home = {
    stateVersion = "25.11";
    shellAliases.c = "clear";
    packages = [ pkgs.prismlauncher ];
  };

  programs = {
    bacon.enable = true;
    bat.enable = true;
    btop.enable = true;
    fzf.enable = true;
    mangohud.enable = true;
    ripgrep.enable = true;
  };

  catppuccin = {
    enable = true;
    accent = "lavender";
  };

  sops = {
    defaultSopsFile = ./secrets.yaml;
    age = {
      keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
      sshKeyPaths = [ "${homeDirectory}/.ssh/id_ed25519" ];
    };
    secrets = {
      "atuin/key" = { };
      "atuin/session" = { };
      "weather.json" = { };
    };
  };
}
