-- stylua: ignore start
vim.opt.belloff:append({ ctrlg = true })                        -- If nvim beeps during completion
vim.opt.cmdheight = 2                                           -- More space for the command bar.
vim.opt.completeopt = { "menuone", "noselect", "noinsert" }     -- Complete options.
vim.opt.confirm = true                                          -- Save files on exit.
vim.opt.cursorline = true                                       -- Show current cursor line.
vim.opt.foldmethod = "syntax"                                   -- Use syntax definitions for folding.
vim.opt.infercase = true                                        -- Adjust case of match for keyword completion.
vim.opt.lazyredraw = true                                       -- Only redraws what is necessary, when necessary.
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
-- stylua: ignore end

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

-- Copy to system clipboard if we're on Windows or Mac.
if vim.fn.has("win32") or vim.fn.has("mac") then
    vim.opt.clipboard = "unnamed"
end

-- Needed for undo-tree, could be moved to plugin settings.
if vim.fn.has("persistent_undo") then
    vim.opt.undofile = true
    if vim.fn.has("win32") then
        vim.opt.undodir = vim.fn.expand("$XDG_CONFIG_HOME") .. "\\nvim-data\\"
    else
        vim.opt.undodir = "~/.undodir/"
    end
end

-- Python settings (needed for everything that needs python). Make sure that we use a venv
-- specific for nvim so we don't have to install pynvim everywhere
if vim.fn.has("win32") then
    -- Note that Windows doesn't use python3, so just set it to python directly.
    vim.g.python3_host_prog = vim.fn.expand("$USERPROFILE") .. "\\nvim\\Scripts\\python"
else
    vim.g.python3_host_prog = "~/nvim/bin/python3"
end
