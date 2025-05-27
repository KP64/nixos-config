{
  config,
  lib,
  pkgs,
  inputs,
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
    ];

    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
      plugins = {
        hexyl = inputs.yazi-hexyl;
        inherit (pkgs.yaziPlugins)
          chmod
          full-border
          git
          mediainfo
          mount
          relative-motions
          smart-enter
          smart-filter
          starship
          toggle-pane
          ouch
          vcs-files
          ;
      };

      initLua = ./init.lua;

      keymap.manager.prepend_keymap =
        [
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
              modeDesc = if mode == "min" then "(un)Minimize" else "(un)Maximize";
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
            num = toString (n + 1);
          in
          {
            on = num;
            run = "plugin relative-motions ${num}";
            desc = "Move in relative steps";
          }
        ) 9);

      settings = {
        manager.show_hidden = true;

        plugin =
          let
            mediainfo = map (a: a // { run = "mediainfo"; }) [
              { mime = "{audio,video,image}/*"; }
              { mime = "application/subrip"; }
            ];
          in
          {
            prepend_preloaders = mediainfo;

            prepend_previewers =
              mediainfo
              ++ (map (a: a // { run = "ouch"; }) [
                { mime = "application/*zip"; }
                { mime = "application/x-tar"; }
                { mime = "application/x-bzip2"; }
                { mime = "application/x-7z-compressed"; }
                { mime = "application/x-rar"; }
                { mime = "application/x-xz"; }
                { mime = "application/xz"; }
              ]);

            append_previewers = [
              {
                name = "*";
                run = "hexyl";
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
