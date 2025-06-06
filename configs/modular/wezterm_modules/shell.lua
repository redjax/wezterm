-- wezterm_modules/shell.lua
return function(config, platform)
    if platform.platform == 'windows' then
      config.default_prog = {'pwsh.exe'}
    elseif platform.platform == 'mac' then
      config.default_prog = {'zsh', '-l'}
    else
      config.default_prog = {'bash', '-l'}
    end
end
