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

-- Useful for debugging user vars.
-- wezterm.on(
--     "user-var-changed",
--     function(_, _, name, value) wezterm.log_info("var", name, value) end
-- )

---@param pane Pane
---@return boolean
local function is_shared_key_proc(pane)
    for _, key in ipairs({ "IS_NVIM", "IS_EXPLORER" }) do
        if pane:get_user_vars()[key] == "true" then return true end
    end

    -- Fallback: check if the foreground process is one we care about.
    for _, pattern in ipairs({ "^n?vim?$", "^ta?s?$", "bat" }) do
        if is_foreground_proc(pattern, pane) then return true end
    end

    return false
end

---@param pane Pane
---@return boolean
local function outside_shared_proc(pane) return not is_shared_key_proc(pane) end

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
        key = "m",
        mods = "LEADER",
        action = act.TogglePaneZoomState,
    },
    {
        key = "D",
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
        key = "h",
        mods = "ALT",
        action = act.ActivatePaneDirection("Left"),
    },
    {
        key = "j",
        mods = "ALT",
        action = act.ActivatePaneDirection("Down"),
    },
    {
        key = "k",
        mods = "ALT",
        action = act.ActivatePaneDirection("Up"),
    },
    {
        key = "l",
        mods = "ALT",
        action = act.ActivatePaneDirection("Right"),
    },
    bind_if(outside_shared_proc, "h", "CTRL", act.ActivatePaneDirection("Left")),
    bind_if(outside_shared_proc, "j", "CTRL", act.ActivatePaneDirection("Down")),
    bind_if(outside_shared_proc, "k", "CTRL", act.ActivatePaneDirection("Up")),
    bind_if(outside_shared_proc, "l", "CTRL", act.ActivatePaneDirection("Right")),
    bind_if(outside_shared_proc, "b", "CTRL", act.ScrollByPage(-1)),
    bind_if(outside_shared_proc, "f", "CTRL", act.ScrollByPage(1)),
    bind_if(outside_shared_proc, "u", "CTRL", act.ScrollByPage(-0.5)),
    bind_if(outside_shared_proc, "d", "CTRL", act.ScrollByPage(0.5)),
    bind_if(outside_shared_proc, "h", "CTRL|SHIFT", act.AdjustPaneSize({ "Left", 5 })),
    bind_if(outside_shared_proc, "j", "CTRL|SHIFT", act.AdjustPaneSize({ "Down", 5 })),
    bind_if(outside_shared_proc, "k", "CTRL|SHIFT", act.AdjustPaneSize({ "Up", 5 })),
    bind_if(outside_shared_proc, "l", "CTRL|SHIFT", act.AdjustPaneSize({ "Right", 5 })),
}

return cfg
