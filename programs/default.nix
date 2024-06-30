{
  imports = [
    ./cli
    ./editors
    ./gaming

    ./firefox.nix
    ./mpv.nix
    ./obs.nix
    ./packages.nix
    # FIXME: For whatever Reason this HAS to be imported by home manager
    #./spicetify.nix
    ./thunderbird.nix
  ];
}
