local common = require("common")
local vs = require("groups.vs")

local cfg = {
    window_close_confirmation = "NeverPrompt",
    exit_behavior = "Close",
}

local launch_cfg = require("groups.launch")
launch_cfg.launch_menu = vs.add_vs_launch(launch_cfg.launch_menu)

local full_cfg = common.merge_all(
    cfg,
    require("groups.ui"),
    require("groups.keys"),
    require("groups.mouse"),
    launch_cfg
)

return full_cfg
