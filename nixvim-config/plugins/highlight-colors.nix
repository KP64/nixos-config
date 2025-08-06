{
  # TODO: LazyLoad
  plugins.highlight-colors = {
    enable = true;
    settings = {
      render = "virtual";
      # Set virtual symbol (requires render to be set to 'virtual')
      virtual_symbol = "■";

      enable_hex = true; # FFFFFF
      enable_short_hex = true; # fff
      enable_rgb = true; # rgb(0 0 0)
      enable_hsl = true; # hsl(150deg 30% 40%)
      enable_ansi = true; # \033[0;34m
      enable_hsl_without_function = true; # --foreground: 0 69% 69%;
      enable_var_usage = true; # var(--testing-color)
      enable_named_colors = true; # green
      enable_tailwind = true; # bg-blue-500
    };
  };
}
