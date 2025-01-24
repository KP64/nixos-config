let
  excludeSecrets = [ "*secrets.yaml" ];
in
{
  settings.global.excludes =
    excludeSecrets
    ++ [ "UNLICENSE" ]
    ++ (map (e: "*.${e}") [
      "png"
      "jpg"
      "lycheeignore"
      # TODO: Remove once justfmt supports module fmt
      "just"
      # TODO: Remove and use `nufmt` once production ready
      "nu"
      "yuck"
    ]);
  programs = {
    deadnix.enable = true;
    just.enable = true;
    mdformat.enable = true;
    nixfmt.enable = true;
    prettier = {
      enable = true;
      excludes = excludeSecrets;
      settings.overrides = [
        {
          files = [ "*.svg" ];
          options.parser = "html";
        }
      ];
      includes = map (l: "*.${l}") [
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
