---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local cfg = {}

cfg.mouse_bindings = {
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "NONE",
        action = wezterm.action_callback(function(window, pane)
            local has_selection = window:get_selection_text_for_pane(pane) ~= ""
            if has_selection then
                window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
                window:perform_action(act.ClearSelection, pane)
            else
                window:perform_action(act.PasteFrom("Clipboard"), pane)
            end
        end),
    },
    {
        event = { Down = { streak = 1, button = "Right" } },
        mods = "SHIFT",
        action = wezterm.action_callback(
            function(window, pane) window:perform_action(act.PasteFrom("Clipboard"), pane) end
        ),
    },
    {
        event = { Up = { streak = 1, button = "Left" } },
        mods = "CTRL",
        action = act.OpenLinkAtMouseCursor,
    },
}

return cfg
