---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

local common = require("utils")

---@param pane Pane
---@param pattern string
---@return boolean
local function is_foreground_proc(pattern, pane)
    return pane:get_foreground_process_name():find(pattern) ~= nil
        or pane:get_title():find(pattern) ~= nil
end

wezterm.on(
    "user-var-changed",
    function(_, _, name, value) wezterm.log_info("var", name, value) end
)

---@param pane Pane
---@return boolean
local function is_shared_key_proc(pane)
    if pane:get_user_vars().IS_NVIM == "true" then return true end
    print(pane:get_user_vars().IS_EXPLORER)
    if pane:get_user_vars().IS_EXPLORER == "true" then return true end

    -- Fallback for windows: check the name of the foreground process/title.
    if common.is_windows() then
        return is_foreground_proc("^n?vim?$", pane) or is_foreground_proc("^ta?s?$", pane)
    end

    -- Fallback for Linux (mainly for the cases where Vim is used)
    if not common.is_windows() then
        local tty = pane:get_tty_name()
        if tty == nil then return false end

        local success, _, _ = wezterm.run_child_process({
            "sh",
            "-c",
            "ps -o state= -o comm= -t"
                .. wezterm.shell_quote_arg(tty)
                .. " | "
                .. "grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'",
        })

        return success
    end
    return false
end

---@param pane Pane
---@return boolean
local function is_outside_shared_proc(pane) return not is_shared_key_proc(pane) end

---@param cond function
---@param key string
---@param mods string
---@param action Action
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
