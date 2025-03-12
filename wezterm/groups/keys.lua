local common = require("common")
local wezterm = require("wezterm")
local act = wezterm.action

--- Return true if the cursor is inside (n)vim, false otherwise.
---@return boolean
local function is_inside_vim(pane)
    if not common.is_windows() then
        local tty = pane:get_tty_name()
        if tty == nil then return false end

        local success, _, _ = wezterm.run_child_process({
            "sh",
            "-c",
            "ps -o state= -o comm= -t"
                .. wezterm.shell_quote_arg(tty)
                .. " | "
                .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vi?m?x?)(diff)?$'",
        })

        return success
    end
    return pane:get_foreground_process_name():find("n?vim?") ~= nil
        or pane:get_title():find("n?vim?") ~= nil
end

local function is_outside_vim(pane) return not is_inside_vim(pane) end

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
    bind_if(is_outside_vim, "h", "CTRL", act.ActivatePaneDirection("Left")),
    bind_if(is_outside_vim, "j", "CTRL", act.ActivatePaneDirection("Down")),
    bind_if(is_outside_vim, "k", "CTRL", act.ActivatePaneDirection("Up")),
    bind_if(is_outside_vim, "l", "CTRL", act.ActivatePaneDirection("Right")),
}

return cfg
