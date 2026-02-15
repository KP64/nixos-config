{
  flake.aspects.users-kg-yazi.homeManager =
    { lib, pkgs, ... }:
    {
      programs.yazi = {
        enable = true;

        # FIXME: Rich-preview doesn't work?
        extraPackages = with pkgs; [
          exiftool
          ouch
          mediainfo
          rich-cli
          trash-cli
        ];

        plugins = {
          inherit (pkgs.yaziPlugins)
            chmod
            full-border
            git
            mediainfo
            mount
            ouch
            piper
            recycle-bin
            relative-motions
            restore
            rich-preview
            smart-enter
            smart-filter
            starship
            toggle-pane
            vcs-files
            ;
        };

        initLua = ./init.lua;

        keymap.mgr.prepend_keymap = [
          {
            on = "<F9>";
            run = "plugin mediainfo -- toggle-metadata";
            dedsc = "Toggle media preview metadata";
          }
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
                  preview = "n";
                  current = "c";
                  parent = "p";
                }
                .${pane};
              m = mode |> lib.stringToCharacters |> lib.last;
              modeDesc = "(un)${lib.toSentenceCase mode}imize";
            in
            {
              on = [
                "T"
                p
                m
              ];
              run = "plugin toggle-pane ${mode}-${pane}";
              desc = "${modeDesc} ${pane}";
            }
          )
        )
        ++ (
          9
          |> builtins.genList (
            n:
            let
              steps = n + 1 |> toString;
            in
            {
              on = steps;
              run = "plugin relative-motions ${steps}";
              desc = "Move in relative steps";
            }
          )
        )
        ++ [
          {
            on = [
              "R"
              "b"
            ];
            run = "plugin recycle-bin";
            desc = "Open Recycle Bin menu";
          }
          {
            on = [
              "R"
              "o"
            ];
            run = "plugin recycle-bin -- open";
            desc = "Open Trash";
          }
          {
            on = [
              "R"
              "e"
            ];
            run = "plugin recycle-bin -- empty";
            desc = "Empty Trash";
          }
          {
            on = [
              "R"
              "D"
            ];
            run = "plugin recycle-bin -- emptyDays";
            desc = "Empty by days deleted";
          }
          {
            on = [
              "R"
              "d"
            ];
            run = "plugin recycle-bin -- delete";
            desc = "Delete from Trash";
          }
          {
            on = [
              "R"
              "r"
            ];
            run = "plugin recycle-bin -- restore";
            desc = "Restore from Trash";
          }
        ]
        ++ [
          {
            on = [ "u" ];
            run = "plugin restore";
            desc = "Restore last deleted files/folders";
          }
          {
            on = [ "U" ];
            run = "plugin restore -- --interactive";
            desc = "Restore deleted files/folders (Interactive)";
          }
        ];

        settings = {
          tasks.image_alloc = 1024 * 1024 * 1024; # 1024MB needed for large media(info) files
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
                    "application/postscript"
                  ];
            in
            {
              prepend_preloaders = mediainfo;

              prepend_previewers =
                (map
                  (ext: {
                    url = "*.${ext}";
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
                    "tar"
                    "bzip2"
                    "7z*"
                    "rar"
                    "xz"
                    "zstd"
                    "java-archive"
                  ]
                );

              append_previewers = [
                {
                  url = "*";
                  run = ''piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
                }
              ];

              prepend_fetchers =
                map
                  (url: {
                    inherit url;
                    id = "git";
                    run = "git";
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
