{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.file-managers.yazi;
in
{
  options.file-managers.yazi.enable = lib.mkEnableOption "Yazi";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      exiftool
      ouch
      hexyl
      mediainfo
      rich-cli
    ];

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        inherit (pkgs.yaziPlugins)
          chmod
          full-border
          git
          mediainfo
          mount
          piper
          relative-motions
          rich-preview
          smart-enter
          smart-filter
          starship
          toggle-pane
          ouch
          vcs-files
          ;
      };

      initLua = ./init.lua;

      keymap.mgr.prepend_keymap = [
        {
          on = "M";
          run = "plugin mount";
        }
        {
          on = [
            "g"
            "r"
          ];
          run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
          desc = "cd to the current Git repo root";
        }
        {
          on = [
            "g"
            "c"
          ];
          run = "plugin vcs-files";
          desc = "Show Git file changes";
        }
        {
          on = "F";
          run = "plugin smart-filter";
          desc = "Smart filter";
        }
        {
          on = [
            "c"
            "m"
          ];
          run = "plugin chmod";
          desc = "Chmod on selected files";
        }
        {
          on = "C";
          run = "plugin ouch";
          desc = "Compress with ouch";
        }
        {
          on = "l";
          run = "plugin smart-enter";
          desc = "Enter the child directory, or open the file";
        }
      ]
      ++ (
        {
          pane = [
            "preview"
            "current"
            "parent"
          ];
          mode = [
            "min"
            "max"
          ];
        }
        |> lib.cartesianProduct
        |> map (
          { pane, mode }:
          let
            p =
              {
                preview = "n"; # (n)ext
                current = "c"; # (c)urrent
                parent = "p"; # (p)revious
              }
              .${pane};
            m = mode |> lib.stringToCharacters |> lib.last;
            modeDesc = "(un)${lib.toSentenceCase mode}imize";
          in
          {
            on = [
              "T"
              m
              p
            ];
            run = "plugin toggle-pane ${mode}-${pane}";
            desc = "${modeDesc} ${pane}";
          }
        )
      )
      ++ (builtins.genList (
        n:
        let
          steps = toString (n + 1);
        in
        {
          on = steps;
          run = "plugin relative-motions ${steps}";
          desc = "Move in relative steps";
        }
      ) 9);

      settings = {
        mgr.show_hidden = true;

        plugin =
          let
            mediainfo =
              map
                (mime: {
                  inherit mime;
                  run = "mediainfo";
                })
                [
                  "{audio,video,image}/*"
                  "application/subrip"
                ];
          in
          {
            prepend_preloaders = mediainfo;

            prepend_previewers =
              (map
                (ext: {
                  name = "*.${ext}";
                  run = "rich-preview";
                })
                [
                  "csv"
                  "md"
                  "rst"
                  "ipynb"
                  "json"
                ]
              )
              ++ mediainfo
              ++ (map
                (arch: {
                  mime = "application/${arch}";
                  run = "ouch";
                })
                [
                  "*zip"
                  "x-tar"
                  "x-bzip2"
                  "x-7z-compressed"
                  "x-rar"
                  "x-xz"
                  "xz"
                ]
              );

            append_previewers = [
              {
                name = "*";
                run = ''piper -- hexyl --border=none --terminal-width=$w "$1"'';
              }
            ];

            prepend_fetchers =
              map
                (name: rec {
                  inherit name;
                  id = "git";
                  run = id;
                })
                [
                  "*"
                  "*/"
                ];
          };

        opener.extract = map (attrs: attrs // { desc = "Extract here with ouch"; }) [
          {
            run = ''ouch d -y "%*"'';
            for = "windows";
          }
          {
            run = ''ouch d -y "$@"'';
            for = "unix";
          }
        ];
      };
    };
  };
}
