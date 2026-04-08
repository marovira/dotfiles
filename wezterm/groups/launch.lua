local common = require("utils")

local cfg = {}

if common.is_windows() then
    local args = {
        os.getenv("USERPROFILE") .. "/scoop/apps/msys2/current/usr/bin/zsh.exe",
        "--login",
    }
    local env = {
        MSYSTEM = "MINGW64",
        MSYS2_PATH_TYPE = "inherit",
        CHERE_INVOKING = "1",
    }

    local launch_menu = {
        {
            label = "MSYS2",
            args = args,
            set_environment_variables = env,
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

    cfg.default_prog = args
    cfg.set_environment_variables = env
    cfg.default_cwd = common.get_default_cwd()
end

return cfg
