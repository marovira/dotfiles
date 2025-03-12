local common = require("common")
local wezterm = require("wezterm")

local M = {}

---@param launch_menu table
---@return table
function M.add_vs_launch(launch_menu)
    if not common.is_windows() then return launch_menu end

    for _, vsvers in
        ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files"))
    do
        local year = vsvers:gsub("Microsoft Visual Studio/", "")
        table.insert(launch_menu, {
            label = "x64 Native Tools VS " .. year,
            args = {
                "cmd.exe",
                "/k",
                "C:/Program Files/"
                    .. vsvers
                    .. "Enterprise"
                    .. "/VC/Auxiliary/Build/vcvars64.bat",
            },
        })
    end

    return launch_menu
end

return M
