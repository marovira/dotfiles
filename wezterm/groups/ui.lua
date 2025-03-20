local common = require("common")
local wezterm = require("wezterm")
local mux = wezterm.mux

local cfg = {}

-- Colour scheme
cfg.color_scheme = "Dracula (Official)"

-- Font settings
cfg.font = wezterm.font("FiraCode Nerd Font")
cfg.font_size = common.is_windows() and 11 or 12

-- Cursor settings
cfg.default_cursor_style = "BlinkingBar"
cfg.cursor_blink_ease_in = "Constant"
cfg.cursor_blink_ease_out = "Constant"

-- Blur + Opacity settings
local default_opacity = common.is_windows() and 0.5 or 0.8
cfg.window_background_opacity = default_opacity
cfg.win32_system_backdrop = "Acrylic"
cfg.macos_window_background_blur = 20

-- Tab settings
cfg.use_fancy_tab_bar = true
cfg.hide_tab_bar_if_only_one_tab = true
cfg.tab_bar_at_bottom = true

cfg.window_decorations = common.is_linux() and "NONE" or "TITLE | RESIZE"

-- Scrollbar/scrollback
cfg.scrollback_lines = 10000
cfg.enable_scroll_bar = true

-- Ensure the window is always maximised
wezterm.on("gui-startup", function(cmd)
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

wezterm.on("window-focus-changed", function(window, _)
    local overrides = window:get_config_overrides() or {}
    if common.is_windows() then
        if window:is_focused() then
            overrides.window_background_opacity = 0.5
        else
            overrides.window_background_opacity = 1
        end
    end
    window:set_config_overrides(overrides)
end)

return cfg
