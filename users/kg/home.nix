{
  config,
  pkgs,
  inputs,
  inputs',
  ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  imports = [
    ./dots
  ]
  ++ (with inputs; [
    catppuccin.homeModules.default
    sops-nix.homeManagerModules.default
    spicetify-nix.homeManagerModules.default
    nixcord.homeModules.default
    nix-index-database.homeModules.nix-index
    nur.modules.homeManager.default
  ]);

  nixpkgs.config.allowUnfree = true;

  programs = {
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    nix-init.enable = true;
    direnv = {
      enable = true;
      silent = true;
      nix-direnv.enable = true;
    };
    nh = {
      enable = true;
      flake = "${homeDirectory}/nixos-config";
      clean = {
        enable = true;
        extraArgs = "--keep 5";
      };
    };
  };

  home = {
    stateVersion = "25.11";
    shellAliases.c = "clear";
    packages = [
      pkgs.prismlauncher
    ]
    ++ (with inputs'; [
      dotz.packages.default
      nix-alien.packages.nix-alien
    ]);
  };

  catppuccin = {
    enable = true;
    accent = "lavender";
    gtk.icon.enable = true;
    cursors = {
      enable = true;
      accent = "dark";
    };
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

  programs = {
    bacon.enable = true;
    bash.enable = true;
    bat.enable = true;
    btop.enable = true;
    cava.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
    gitui.enable = true;
    git-cliff.enable = true;
    lsd = {
      enable = true;
      settings.sorting.dir-grouping = "first";
    };
    mangohud.enable = true;
    ripgrep.enable = true;
    zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
    };
  };
}
