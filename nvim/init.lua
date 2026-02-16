-- Options
-- =======================
require("options")

-- Autocommands
-- =======================
require("autocmd")

-- Custom Commands
-- =======================
require("commands")

-- Key remaps
-- =======================
require("maps")

-- GUI options
-- =======================
require("gui")

-- Plug-ins
-- =======================
-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazy_path) then
    local lazy_repo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazy_repo,
        lazy_path,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit" },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("plugins", { rocks = { enabled = false } })
