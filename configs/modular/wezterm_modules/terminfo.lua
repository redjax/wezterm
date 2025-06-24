local function get_home_dir()
    -- Set $HOME path
    return os.getenv("HOME") or os.getenv("USERPROFILE") or ""
end
  
return function(config)
    local home = get_home_dir()

    local terminfo_paths = {
        home ~= "" and (home .. "/.terminfo/w/wezterm") or nil,
        "/usr/share/terminfo/w/wezterm",
        "/lib/terminfo/w/wezterm",
        "/usr/local/share/terminfo/w/wezterm",
    }

    local found = false

    -- Check if wezterm terminfo exists
    for _, path in ipairs(terminfo_paths) do
      if path then
        local f = io.open(path, "r")
        if f then
          f:close()
          found = true
          break
        end
      end
    end

    -- Set terminal scrollback memory
    config.scrollback_lines = 3500

    -- Enable advanced wezterm features if wezterm terminfo exists
    -- config.term = found and "wezterm" or "xterm-256color"
  end
  
