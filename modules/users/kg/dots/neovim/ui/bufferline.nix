{
  den.aspects.kg.homeManager = { config, ... }: {
    programs.nixvim.plugins.bufferline = {
      enable = true;
      settings.options.numbers = config.lib.nixvim.mkRaw ''
        function(opts)
            return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
        end
      '';
    };
  };
}
