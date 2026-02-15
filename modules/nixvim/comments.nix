{
  flake.aspects.comments.nixvim = {
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

    plugins.todo-comments = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
      keymaps = {
        todoTrouble.key = "<leader>tt";
        todoTelescope.key = "<leader>ft";
      };
    };
  };
}
