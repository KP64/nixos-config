{ username, ... }:
{
  # TODO: NuShell may be not enabled
  home-manager.users.${username}.programs.kitty = {
    enable = true;
    font.name = "JetBrainsMono Nerd Font";
    settings = {
      shell = "nu";
      background_opacity = "0.8";
    };
  };
}
