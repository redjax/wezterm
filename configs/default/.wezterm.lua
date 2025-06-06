-- Import wezterm
local wezterm = require 'wezterm'

-- Config object
local config = wezterm.config_builder()

-- Set initial window geometry
config.initial_cols = 120
config.initial_rows = 28

-- Change font size, color
config.font_size = 10
config.color_scheme = 'AdventureTime'

-- KEEP THIS AT THE BOTTOM OF YOUR CONFIG
return config

