-- Import wezterm
local wezterm = require 'wezterm'

-- Config object
local config = wezterm.config_builder()

-- Detect platform
-- \ Example: config.font_size = is_windows and 12 or is_mac and 16 or 14
local is_linux = wezterm.target_triple:find('linux') ~= nil
local is_windows = wezterm.target_triple:find('windows') ~= nil
local is_mac = wezterm.target_triple:find('darwin') ~= nil

-- Function to detect platform
local function get_platform()
    if is_linux then return 'linux'
    elseif is_windows then return 'windows'
    elseif is_mac then return 'mac'
    end
end

-- Function to detect dark/light system setting
local function get_appearance()
    if wezterm.gui then
      return wezterm.gui.get_appearance()
    end
    return 'Dark'
end

-- Set theme based on system appearance
-- \ https://wezterm.org/config/appearance.html#color-scheme
local function scheme_for_appearance(appearance)
    if appearance:find 'Dark' then
        return 'OneDark (base16)'
    else
        return 'One Light (base16)'
    end
end

-- Set color scheme dynamically
config.color_scheme = scheme_for_appearance(get_appearance())

-- Set variable with platform string
local platform = get_platform()

-- Set font fallbacks per platform
local font_fallback = {
    linux = {'DejaVu Sans Mono', 'Liberation Mono'},
    windows = {'Consolas', 'Courier New'},
    mac = {'SF Mono', 'Menlo', 'Monaco'},
}

-- Set initial window geometry
config.initial_cols = 120
config.initial_rows = 28

-- Set term starting directory
config.default_cwd = wezterm.home_dir

-- Change font size
config.font_size = 12

-- Try fonts, falling back through an array of fonts to find one that works
config.font = wezterm.font_with_fallback(
  {
    'Hack Nerd Font Mono',
    'FiraCode Nerd Font Mono',
    table.unpack(font_fallback[platform] or {'DejaVu Sans Mono'})
  }
)

-- Makes fallback fonts visually consistent
config.use_cap_height_to_scale_fallback_fonts = true

-- Set shell based on platform
if get_platform() == 'windows' then
    config.default_prog = {'pwsh.exe'}
  elseif get_platform() == 'mac' then
    config.default_prog = {'zsh', '-l'}
  else
    config.default_prog = {'bash', '-l'}
end  

-- Set terminal scrollback memory
config.scrollback_lines = 3500

-- Vertical spacing
config.line_height = 1.1

-- Visual for insactive tabs
config.inactive_pane_hsb = {saturation=0.8, brightness=0.7}

-- Remove title bar
-- \ Default: "TITLE | RESIZE"
config.window_decorations = "TITLE | RESIZE"

-- Hide tab bar when only 1 tab is open
config.hide_tab_bar_if_only_one_tab = true

-- Set max FPS for terminal
config.max_fps = 120

-- Window padding
config.window_padding = {
    left = 4, right = 4, top = 2, bottom = 2,
} 

-- Enable scrollbar
config.enable_scroll_bar = true

-- Set command palette font size
config.command_palette_font_size = 13

-- ############
-- # KEYBINDS #
-- ############
config.keys = {
    -- ALT+ENTER = split horizontal
    {key="Enter", mods="ALT", action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
    -- CTRL+SHIFT+ENTER = split vertical
    {key="Enter", mods="CTRL|SHIFT", action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
    -- CTRL+SHIFT+P = command palette
    {
        key = 'P',
        mods = 'CTRL|SHIFT',
        action = wezterm.action.ActivateCommandPalette,
    },
}  

-- KEEP THIS AT THE BOTTOM OF YOUR CONFIG
return config

