return function(config)
    -- Set mouse bindings
    config.mouse_bindings = {
      {
        -- CTRL+LeftClick = open link
        event={Up={streak=1, button="Left"}},
        mods="CTRL",
        action="OpenLinkAtMouseCursor",
      },
    }
end
  