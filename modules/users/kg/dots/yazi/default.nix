{
  den.aspects.kg._.yazi.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      programs.yazi = {
        enable = true;

        extraPackages = with pkgs; [
          exiftool
          mediainfo
          ouch
          rich-cli
          trash-cli
        ];

        plugins =
          let
            inherit (pkgs) yaziPlugins;
          in
          {
            inherit (yaziPlugins)
              chmod
              mediainfo
              mount
              ouch
              piper
              restore
              rich-preview
              smart-enter
              smart-filter
              toggle-pane
              vcs-files
              ;

            full-border = {
              package = yaziPlugins.full-border;
              setup = true;
            };
            git = {
              package = yaziPlugins.git;
              setup = true;
            };
            recycle-bin = {
              package = yaziPlugins.recycle-bin;
              setup = true;
            };
            relative-motions = {
              package = yaziPlugins.relative-motions;
              setup = true;
              settings.show_numbers = "relative";
            };
            starship = {
              package = yaziPlugins.starship;
              setup = true;
              settings.config_file = config.programs.starship.configPath;
            };
          };

        initLua = ./init.lua;

        keymap.mgr.prepend_keymap = [
          {
            on = "<F3>";
            run = "plugin mediainfo -- toggle-metadata";
            desc = "Toggle media preview metadata";
          }
          {
            on = "<F4>";
            run = "plugin mediainfo -- toggle-preview";
            desc = "Toggle media preview image";
          }
          {
            on = "<F6>";
            run = "plugin mediainfo -- hide-metadata";
            desc = "Hide media preview metadata";
          }
          {
            on = "<F7>";
            run = "plugin mediainfo -- hide-preview";
            desc = "Hide media preview image";
          }
          {
            on = "<F8>";
            run = "plugin mediainfo -- show-metadata";
            desc = "Show media preview metadata";
          }
          {
            on = "<F9>";
            run = "plugin mediainfo -- show-preview";
            desc = "Show media preview image";
          }
          {
            on = "<F5>";
            run = "plugin mediainfo -- reset";
            desc = "Reset media preview to default settings";
          }
          {
            on = "<F10>";
            run = "plugin mediainfo -- --toggle-preview --toggle-metadata";
            desc = "Toggle both media preview image and metadata";
          }
          {
            on = "<F11>";
            run = "plugin mediainfo -- --show-preview --hide-metadata";
            desc = "Show media preview image and hide metadata";
          }
          {
            on = "<F12>";
            run = "plugin mediainfo -- --show-preview --hide-metadata --reset --show-metadata --hide-preview";
            desc = "Show media preview image and hide metadata";
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
        ++ (builtins.genList (
          n:
          let
            steps = n + 1 |> toString;
          in
          {
            on = steps;
            run = "plugin relative-motions ${steps}";
            desc = "Move in relative steps";
          }
        ) 9)
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
                    "application/illustrator"
                    "application/dvb.ait"
                    "application/vnd.adobe.illustrator"
                    "image/x-eps"
                    "application/eps"
                    "*.{ai,eps,ait}"
                  ];
            in
            {
              prepend_preloaders = mediainfo;

              prepend_previewers = mediainfo ++ [
                {
                  url = "*.{csv,md,rst,ipynb,json}";
                  run = "rich-preview";
                }
                {
                  mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
                  run = "ouch --show-file-icons";
                }
              ];
              append_previewers = [
                {
                  url = "*";
                  run = ''piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
                }
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
