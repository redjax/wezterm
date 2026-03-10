local function get_home_dir()
    -- Set $HOME path
    return os.getenv("HOME") or os.getenv("USERPROFILE") or ""
end

local function wezterm_terminfo_exists()
    local home = get_home_dir()

    local terminfo_paths = {
        home ~= "" and (home .. "/.terminfo/w/wezterm") or nil,
        "/usr/share/terminfo/w/wezterm",
        "/lib/terminfo/w/wezterm",
        "/usr/local/share/terminfo/w/wezterm",
    }

    for _, path in ipairs(terminfo_paths) do
      if path then
        local f = io.open(path, "r")
        if f then
          f:close()
          return true
        end
      end
    end

    return false
end

return function(config)
    -- Set terminal scrollback memory
    config.scrollback_lines = 10000

    -- Enable advanced wezterm features if wezterm terminfo exists
    if wezterm_terminfo_exists() then
      config.term = "wezterm"
    else
      config.term = "xterm-256color"
    end
  end
  
