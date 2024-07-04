local common = require("common")
local opts = {
    shell = function()
        -- Force the shell to be bash on windows.
        if common.is_windows() then
            return "bash"
        else
            return vim.o.shell
        end
    end,
    open_mapping = "<C-\\>",
    start_in_insert = true,
    direction = "float",
    close_on_exit = true,
}

return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        opts = opts,
    },
}
