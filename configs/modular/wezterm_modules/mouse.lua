local wezterm = require 'wezterm'
local act = wezterm.action

return function(config)
  config.mouse_bindings = {
    {
      -- CTRL+LeftClick = open link
      event = { Up = { streak = 1, button = "Left" } },
      mods = "CTRL",
      action = act.OpenLinkAtMouseCursor,
    },
    {
      -- RightClick: Copy if selection, else paste
      event = { Down = { streak = 1, button = "Right" } },
      mods = "NONE",
      action = wezterm.action_callback(function(window, pane)
        local sel = window:get_selection_text_for_pane(pane)
        if sel ~= "" then
          window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
          window:perform_action(act.ClearSelection, pane)
        else
          window:perform_action(act.PasteFrom("Clipboard"), pane)
        end
      end),
    },
  }
end
