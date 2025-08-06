{
  plugins.dashboard = {
    enable = true;
    lazyLoad.settings.event = "VimEnter";
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
