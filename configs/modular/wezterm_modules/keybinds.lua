local wezterm = require 'wezterm'

return function(config)
    -- Define keybinds
    config.keys = {
        -- ALT+ENTER = split horizontal
        {key="Enter", mods="ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        -- CTRL+SHIFT+ENTER = split vertical
        {key="Enter", mods="CTRL|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        -- CTRL+SHIFT+P = command palette
        {key = 'P', mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCommandPalette},
    }
end
