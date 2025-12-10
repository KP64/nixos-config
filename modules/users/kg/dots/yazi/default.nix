{
  flake.modules.homeManager.users-kg-yazi =
    { lib, pkgs, ... }:
    {
      allowedUnfreePackages = [ "ouch" ];

      programs.yazi = {
        enable = true;
        shellWrapperName = "y";

        # FIXME: Rich-preview doesn't work?
        extraPackages = with pkgs; [
          exiftool
          (ouch.override { enableUnfree = true; })
          mediainfo
          rich-cli
        ];

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

        # The readFile seems unnecessary but it makes
        # rebuilding fail when the file doesn't exist
        # instead of silently failing.
        initLua = builtins.readFile ./init.lua;

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
        );

        settings = {
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
                  run = ''piper -- ${lib.getExe pkgs.hexyl} --border=none --terminal-width=$w "$1"'';
                }
              ];

              prepend_fetchers =
                map
                  (name: {
                    inherit name;
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
