local common = require("common")

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- stylua: ignore start
vim.opt.belloff:append({ ctrlg = true })                        -- If nvim beeps during completion
vim.opt.cmdheight = 2                                           -- More space for the command bar.
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }     -- Complete options.
vim.opt.confirm = true                                          -- Save files on exit.
vim.opt.cursorline = true                                       -- Show current cursor line.
vim.opt.infercase = true                                        -- Adjust case of match for keyword completion.
vim.opt.modeline = true                                         -- Enable top-of-file modelines.
vim.opt.mouse = "a"                                             -- Enable mouse clicks.
vim.opt.mousefocus = true                                       -- Focus follows mouse.
vim.opt.number = true                                           -- Set hybrid line numbers
vim.opt.relativenumber = true                                   -- Ditto.
vim.opt.shortmess:append({ ac = true })                         -- Turn off completion messages.
vim.opt.spell = true                                            -- Spelling.
vim.opt.spelllang = "en_gb"                                     -- Use GB English.
vim.opt.startofline = false                                     -- Don't move cursor on line jumps.
vim.opt.tw = 90                                                 -- Text width. Should match all formatting tools.
vim.opt.showmode = false                                        -- Disable showing mode in command bar
vim.opt.showcmd = false                                         -- Disable showing commands
-- stylua: ignore end

-- Diagnostic options
vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
        },
    },
})

-- Diff options
vim.opt.diffopt = "filler,internal,closeoff,algorithm:histogram,context:5,linematch:60"

-- List chars
local space = "."
vim.opt.listchars:append({
    tab = "|-",
    multispace = space,
    lead = space,
    trail = "~",
    nbsp = space,
    eol = "$",
})

-- Fold options
vim.o.foldenable = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldlevel = 99

-- File format settings.
vim.opt.encoding = "utf-8"
vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos" }

-- Tab settings. Should also match all formatting tools.
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Map leader and localleader to ,
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Highlight column width.
vim.cmd("let &colorcolumn=join(range(&tw,&tw), ',')")

-- Allow copying to system clipboard.
vim.opt.clipboard = "unnamedplus"

-- Needed for undo-tree, could be moved to plugin settings.
if vim.fn.has("persistent_undo") then
    vim.opt.undofile = true
    vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"
end

-- Python settings (needed for everything that needs python). Make sure that we use a venv
-- specific for nvim so we don't have to install pynvim everywhere
if common.is_windows() then
    -- Note that Windows doesn't use python3, so just set it to python directly.
    vim.g.python3_host_prog = vim.fn.expand("$USERPROFILE") .. "\\nvim\\Scripts\\python"
else
    vim.g.python3_host_prog = "~/nvim/bin/python3"
end

-- Set the IS_NVIM variable so WexTerm knows we're in vim.
common.set_wezterm_user_var("IS_NVIM", true)
