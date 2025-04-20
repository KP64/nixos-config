let
  excludeSecrets = [ "*secrets.yaml" ];
  mapExtension = l: map (e: "*.${e}") l;
in
{
  settings.global.excludes =
    excludeSecrets
    ++ [
      "UNLICENSE"
      "assets/topology/*"
    ]
    ++ (mapExtension [
      "pub"
      "jpg"
      "lycheeignore"
      "yuck"
    ]);
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
    oxipng.enable = true;

    # 🐚 Shell
    shfmt.enable = true;

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
    prettier = {
      enable = true;
      excludes = excludeSecrets;
      settings.overrides = [
        {
          files = [ "*.svg" ];
          options.parser = "html";
        }
      ];
      includes = mapExtension [
        "cjs"
        "css"
        "html"
        "js"
        "json"
        "json5"
        "jsx"
        "md"
        "mdx"
        "mjs"
        "scss"
        "ts"
        "tsx"
        "vue"
        "yaml"
        "yml"
        "svg"
      ];
    };
  };
}
