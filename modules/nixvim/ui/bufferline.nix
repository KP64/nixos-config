{
  flake.modules.nixvim.bufferline =
    { lib, ... }:
    {
      plugins.bufferline = {
        enable = true;
        settings.options.numbers =
          lib.nixvim.mkRaw # lua
            ''
              function(opts)
                  return string.format('%s·%s', opts.raise(opts.id), opts.lower(opts.ordinal))
              end
            '';
      };
    };
}
