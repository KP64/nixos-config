{
  plugins.dashboard = {
    enable = true;
    settings = {
      config = {
        header = [
          "███╗   ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║   ██║██║██╔████╔██║"
          "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];

        packages.enable = false;
        footer = [ "Made with 😅, 🥹 & 🩸" ];

        shortcut = [
          {
            action = "Telescope find_files cwd=";
            desc = "Files";
            group = "Label";
            icon = " ";
            icon_hl = "@variable";
            key = "f";
          }
        ];
      };
    };
  };
}
