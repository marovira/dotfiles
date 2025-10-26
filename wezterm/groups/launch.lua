local common = require("utils")

local cfg = {}

if common.is_windows() then
    local launch_menu = {
        {
            label = "Git Bash",
            args = { "bash.exe" },
        },
        {
            label = "Command Prompt",
            args = { "cmd.exe" },
        },
        {
            label = "Powershell",
            args = { "powershell.exe", "-NoLogo" },
        },
    }

    cfg.launch_menu = launch_menu

    cfg.default_prog = { "bash.exe" }
    cfg.default_cwd = common.get_default_cwd()
end

return cfg
