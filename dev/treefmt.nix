{
  settings.global.excludes = [ "*secrets.yaml" ];

  programs = {
    # 🐙 Github Actions
    actionlint.enable = true;

    # Just
    just.enable = true;

    # ❄️ Nix
    deadnix.enable = true;
    statix.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };

    # PNG
    oxipng = {
      enable = true;
      opt = "max";
      strip = "safe";
    };

    # 🐚 Shell
    shfmt.enable = true;
    shellcheck.enable = true;

    # TOML
    taplo.enable = true;
    toml-sort.enable = true;

    # 🪐 Lua
    stylua = {
      enable = true;
      settings = {
        indent_type = "Spaces";
        sort_requires.enabled = true;
      };
    };

    # Multiple
    prettier.enable = true;
  };
}
