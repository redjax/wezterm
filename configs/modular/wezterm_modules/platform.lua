local wezterm = require 'wezterm'

local is_linux = wezterm.target_triple:find('linux') ~= nil
local is_windows = wezterm.target_triple:find('windows') ~= nil
local is_mac = wezterm.target_triple:find('darwin') ~= nil

local platform = is_linux and 'linux'
    or is_windows and 'windows'
    or is_mac and 'mac'

return {
  is_linux = is_linux,
  is_windows = is_windows,
  is_mac = is_mac,
  platform = platform,
}
