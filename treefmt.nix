{
  programs = {
    deadnix.enable = true;
    just.enable = true;
    mdformat.enable = true;
    nixfmt.enable = true;
    prettier = {
      enable = true;
      excludes = [ "*secrets.yaml" ];
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
