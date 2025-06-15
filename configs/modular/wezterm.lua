local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local platform = require('wezterm_modules.platform')

require('wezterm_modules.appearance')(config, platform)
require('wezterm_modules.fonts')(config, platform)
require('wezterm_modules.shell')(config, platform)
require('wezterm_modules.terminfo')(config, platform)
require('wezterm_modules.window')(config, platform)
require('wezterm_modules.tabs')(config, platform)
require('wezterm_modules.keybinds')(config)
require('wezterm_modules.mouse')(config)
require('wezterm_modules.env')(config)

return config
