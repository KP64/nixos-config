{
  flake-file.inputs.bedrock-on-linux = {
    url = "github:Wyze3306/BedrockOnLinux";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.kg.homeManager =
    {
      host,
      lib,
      inputs',
      ...
    }:
    lib.optionalAttrs host.isGamingCapable {
      programs.prismlauncher.enable = true;
      home.packages = [ inputs'.bedrock-on-linux.packages.default ];
    };
}
