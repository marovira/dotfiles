local common = require("common")
local wezterm = require("wezterm")
local act = wezterm.action

--- Check if the foreground process matches the given pattern.
---@param pattern string
---@return boolean
local function is_foreground_proc(pattern, pane)
    return pane:get_foreground_process_name():find(pattern) ~= nil
        or pane:get_title():find(pattern) ~= nil
end

local function is_inside_shared_poc(pane)
    return is_foreground_proc("n?vim?", pane) or is_foreground_proc("^ta?s?$", pane)
end

local function is_outside_shared_proc(pane) return not is_inside_shared_poc(pane) end

local function bind_if(cond, key, mods, action)
    local function callback(win, pane)
        if cond(pane) then
            win:perform_action(action, pane)
        else
            win:perform_action(act.SendKey({ key = key, mods = mods }), pane)
        end
    end

    return { key = key, mods = mods, action = wezterm.action_callback(callback) }
end

local cfg = {}

cfg.disable_default_key_bindings = true
cfg.leader = { key = "Space", mods = "ALT", timeout_miliseconds = 2000 }

cfg.keys = {
    {
        key = "C",
        mods = "CTRL|SHIFT",
        action = act.CopyTo("Clipboard"),
    },
    {
        key = "V",
        mods = "CTRL|SHIFT",
        action = act.PasteFrom("Clipboard"),
    },
    {
        key = "\\",
        mods = "LEADER",
        action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "-",
        mods = "LEADER",
        action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
        key = "h",
        mods = "CTRL|SHIFT",
        action = act.AdjustPaneSize({ "Left", 5 }),
    },
    {
        key = "l",
        mods = "CTRL|SHIFT",
        action = act.AdjustPaneSize({ "Right", 5 }),
    },
    {
        key = "j",
        mods = "CTRL|SHIFT",
        action = act.AdjustPaneSize({ "Down", 5 }),
    },
    {
        key = "k",
        mods = "CTRL|SHIFT",
        action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
        key = "m",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },
    {
        key = "L",
        mods = "CTRL",
        action = act.ShowDebugOverlay,
    },
    {
        key = "n",
        mods = "CTRL|SHIFT",
        action = act.SpawnWindow,
    },
    {
        key = "t",
        mods = "CTRL|SHIFT",
        action = act.SpawnCommandInNewTab({
            cwd = common.get_default_cwd(),
        }),
    },
    {
        key = "p",
        mods = "CTRL|SHIFT",
        action = act.ActivateCommandPalette,
    },
    {
        key = "l",
        mods = "CTRL|SHIFT",
        action = act.ShowLauncher,
    },
    {
        key = "Tab",
        mods = "CTRL",
        action = act.ActivateTabRelative(1),
    },
    {
        key = "Tab",
        mods = "CTRL|SHIFT",
        action = act.ActivateTabRelative(-1),
    },
    {
        key = "r",
        mods = "CTRL|SHIFT",
        action = act.ReloadConfiguration,
    },
    {
        key = "f",
        mods = "CTRL|SHIFT",
        action = act.Search({ CaseSensitiveString = "" }),
    },
    {
        key = "LeftArrow",
        mods = "ALT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "DownArrow",
        mods = "ALT",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "UpArrow",
        mods = "ALT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "RightArrow",
        mods = "ALT",
        action = act.ActivatePaneDirection("Right"),
    },
    bind_if(is_outside_shared_proc, "h", "CTRL", act.ActivatePaneDirection("Left")),
    bind_if(is_outside_shared_proc, "j", "CTRL", act.ActivatePaneDirection("Down")),
    bind_if(is_outside_shared_proc, "k", "CTRL", act.ActivatePaneDirection("Up")),
    bind_if(is_outside_shared_proc, "l", "CTRL", act.ActivatePaneDirection("Right")),
    bind_if(is_outside_shared_proc, "b", "CTRL", act.ScrollByPage(-1)),
    bind_if(is_outside_shared_proc, "f", "CTRL", act.ScrollByPage(1)),
    bind_if(is_outside_shared_proc, "u", "CTRL", act.ScrollByPage(-0.5)),
    bind_if(is_outside_shared_proc, "d", "CTRL", act.ScrollByPage(0.5)),
}

return cfg
