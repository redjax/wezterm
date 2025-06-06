return function(config)
    -- Set tab width
    config.tab_max_width = 25
    -- Make tab bar 'fancy'
    config.use_fancy_tab_bar = true
    -- Hide tab bar if only one tab
    config.hide_tab_bar_if_only_one_tab = true
    -- Set inactive tab color
    config.inactive_pane_hsb = {saturation=0.8, brightness=0.7}
  end
  