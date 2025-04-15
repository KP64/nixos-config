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

      # TODO: yatline
      plugins = {
        hexyl = inputs.yazi-hexyl;
        inherit (pkgs.yaziPlugins)
          chmod
          full-border
          git
          mediainfo
          mount
          smart-filter
          starship
          ouch
          vcs-files
          ;
      };

      initLua = # lua
        ''
          require("full-border"):setup()
          require("git"):setup()
          require("starship"):setup()
        '';

      keymap.manager.prepend_keymap = [
        {
          on = "M";
          run = "plugin mount";
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
      ];

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
                (
                  names:
                  names
                  // rec {
                    id = "git";
                    run = id;
                  }
                )
                [
                  { name = "*"; }
                  { name = "*/"; }
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
