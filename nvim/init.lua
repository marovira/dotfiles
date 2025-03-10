-- Options
-- =======================
require("options")

-- Plug-ins
-- =======================
-- Bootstrap lazy.nvim
local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
---@diagnostic disable: undefined-field
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

require("lazy").setup("plugins", { rocks = { enabled = false } })

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
