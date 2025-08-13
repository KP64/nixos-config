{
  plugins.comment = {
    enable = true;
    lazyLoad.settings.keys =
      map (k: "gb${k}") [
        ""
        "c"
      ]
      ++ map (k: "gc${k}") [
        ""
        "c"
        "O"
        "o"
        "A"
      ];
  };
}
