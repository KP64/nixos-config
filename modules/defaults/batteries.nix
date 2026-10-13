{ den, ... }: {
  den.default.includes = with den.batteries; [
    define-user
    hostname
    flake-scope
  ];
}
