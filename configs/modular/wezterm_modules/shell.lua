return function(config, platform)
    if platform.is_windows then
      config.default_prog = {'pwsh.exe'}

    -- Wezterm will use a Unix machine's default $SHELL.
    -- You can optionally override that here.
    -- elseif platform.is_mac then
    --   config.default_prog = {'zsh', '-l'}
    -- elseif platform.is_linux then
    --   config.default_prog = {'bash', '-l'}
    end
end
