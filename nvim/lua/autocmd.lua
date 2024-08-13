-- Used to determine if the file we're opening is "large". This is then used to disable a
-- bunch of state to allow files to load faster. In this context, large files start at
-- 100MB.
local function is_large_file()
    local min_size = 1024 * 1024 * 100
    local f = vim.fn.expand("<afile>")
    if vim.fn.getfsize(f) > min_size then
        return true
    end

    return false
end

-- Autocommands
-- =======================
local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

-- Makes it so neovim reloads the file whenever a change has been made externally.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.api.nvim_command("checktime")
        end
    end,
})

-- Treat all h/c files as C++. In the event I ever write C again, this will be changed
-- accordingly.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { ".h", "*.c" },
    group = augroup,
    command = "set filetype=cpp",
})

-- Property sheets prefer 2 spaces instead of 4, so override those settings while ensuring
-- they get treated as XML files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.props" },
    group = augroup,
    callback = function()
        vim.cmd("set filetype=xml")
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Ensure shader files are appropriately recognised.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.vert", "*.tesc", "*.tese", "*.geom", "*.frag", "*.comp" },
    group = augroup,
    command = "set filetype=glsl",
})

-- Allow detection of Objective C++.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.mm",
    group = augroup,
    command = "set filetype=objcpp",
})

-- Disable folds in JSON and markdown.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.json", "*.md" },
    group = augroup,
    command = "silent! :set nofoldenable",
})

-- Switch to absolute line numbers in insert mode.
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    pattern = "*",
    group = augroup,
    command = "silent! :set nornu number",
})

-- Switch back to relative numbers in normal mode.
vim.api.nvim_create_autocmd({ "InsertLeave", "BufNewFile", "VimEnter" }, {
    pattern = "*",
    group = augroup,
    command = "silent! :set rnu number",
})

-- If a file is large, disable the necessary state to allow faster loads.
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if is_large_file() then
            -- stylua: ignore start
            vim.opt_local.bufhidden = "unload"                                  -- Save memory buffer is hidden.
            vim.opt_local.buftype = "nowrite"                                   -- Is read-only
            vim.opt_local.eventignore = vim.opt_local.eventignore + "FileType"  -- Ignore FileType autocommands.
            vim.opt_local.undolevels = -1                                       -- No undo.
            vim.opt_local.foldenable = false                                    -- Disable folding.
            --stylua: ignore end
        end
    end,
})

-- Highlight common comment headers.
vim.api.nvim_create_autocmd({ "Syntax" }, {
    pattern = "*",
    group = augroup,
    command = "call matchadd('Todo', '\\W\\zs\\(TODO\\|FIXME\\|CHANGED\\|XXX\\|BUG\\|HACK\\)')",
})

vim.api.nvim_create_autocmd({ "Syntax" }, {
    pattern = "*",
    group = augroup,
    command = "call matchadd('Debug', '\\W\\zs\\(NOTE\\|INFO\\|IDEA\\)')",
})
