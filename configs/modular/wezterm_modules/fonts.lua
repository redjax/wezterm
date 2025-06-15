local wezterm = require 'wezterm'

return function(config)
    -- Set font fallbacks
    local font_fallback = {
      linux = {'DejaVu Sans Mono', 'Liberation Mono'},
      windows = {'Consolas', 'Courier New'},
      mac = {'SF Mono', 'Menlo', 'Monaco'},
    }
    
    -- Set font, or fallback to defaults
    config.font = wezterm.font_with_fallback({
      -- Default font, installed with wezterm
      'JetBrains Mono',
      'Hack Nerd Font Mono',
      'FiraCode Nerd Font Mono',
      table.unpack(font_fallback[config._platform] or {'JetBrains Mono'})
    })

    -- Set font size
    config.font_size = 12
    -- Make fallback fonts visually consistent
    config.use_cap_height_to_scale_fallback_fonts = true
    -- Set vertical line spacing
    config.line_height = 1.1
end
