---@param value boolean
---@param global boolean
local function set_ale_fixers(value, global)
    if global then
        vim.g.ale_fix_on_save = value
    else
        vim.b.ale_fix_on_save = value
    end
end

local function toggle_ale_fixers(global)
    local state = {
        global = vim.g.ale_fix_on_save,
        buffer = vim.b.ale_fix_on_save,
    }

    if global then
        state.global = not state.global
    else
        state.buffer = not state.buffer
    end

    vim.g.ale_fix_on_save = state.global
    vim.b.ale_fix_on_save = state.buffer
end

vim.api.nvim_create_user_command(
    "ALEDisableFixers",
    function(_) set_ale_fixers(false, true) end,
    { nargs = 0, desc = "Disable ALE fixers" }
)
vim.api.nvim_create_user_command(
    "ALEEnableFixers",
    function(_) set_ale_fixers(true, true) end,
    { nargs = 0, desc = "Enable ALE fixers" }
)
vim.api.nvim_create_user_command(
    "ALEDisableFixersBuffer",
    function(_) set_ale_fixers(false, false) end,
    { nargs = 0, desc = "Disable ALE fixers on buffer" }
)
vim.api.nvim_create_user_command(
    "ALEEnableFixersBuffer",
    function(_) set_ale_fixers(true, false) end,
    { nargs = 0, desc = "Enable ALE fixers on buffer" }
)
vim.api.nvim_create_user_command(
    "ALEToggleFixers",
    function(_) toggle_ale_fixers(true) end,
    { nargs = 0, desc = "Toggle ALE fixers" }
)
vim.api.nvim_create_user_command(
    "ALEToggleFixersBuffer",
    function(_) toggle_ale_fixers(false) end,
    { nargs = 0, desc = "Toggle ALE fixers buffer" }
)
