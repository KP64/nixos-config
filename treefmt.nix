let
  excludeSecrets = [ "*secrets.yaml" ];
  mapExtension = l: map (e: "*.${e}") l;
in
{
  settings.global.excludes =
    excludeSecrets
    ++ [ "UNLICENSE" ]
    ++ (mapExtension [
      "pub"
      "jpg"
      "lycheeignore"
      "yuck"
    ]);
  programs = {
    actionlint.enable = true;
    deadnix.enable = true;
    just.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    oxipng.enable = true;
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
    shfmt.enable = true;
    statix.enable = true;
    taplo.enable = true;
    toml-sort.enable = true;
  };
}
