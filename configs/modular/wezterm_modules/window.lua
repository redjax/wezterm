return function(config)
    -- Set window geometry
    config.initial_cols = 122
    config.initial_rows = 28

    -- Set default working directory
    config.default_cwd = require('wezterm').home_dir

    -- Disable window close confirmation
    config.window_close_confirmation = "NeverPrompt"

    -- Set term window opacity
    config.window_background_opacity = 0.95

    -- Set window decorations
    config.window_decorations = "TITLE | RESIZE"

    -- Set window padding
    config.window_padding = { left = 4, right = 4, top = 2, bottom = 2 }

    -- Show scrollbar
    config.enable_scroll_bar = true

    -- Set max fps
    config.max_fps = 120
end
