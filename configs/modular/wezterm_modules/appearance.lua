local wezterm = require 'wezterm'

return function(config)
    -- Function to detect dark/light system setting
    local function get_appearance()
      if wezterm.gui then
        return wezterm.gui.get_appearance()
      end
      return 'Dark'
    end

    -- Function to return color scheme based on appearance
    -- \ Color schemes: https://wezfurlong.org/wezterm/colorschemes/
    local function scheme_for_appearance(appearance)
      if appearance:find 'Dark' then
        -- return 'Oxocarbon Dark (Gogh)'
        return 'Argonaut (Gogh)'
      else
        return 'One Light (Gogh)'
      end
    end
  
    -- Set color scheme dynamically
    config.color_scheme = scheme_for_appearance(get_appearance())
end
