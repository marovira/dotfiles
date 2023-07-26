-- Is used to determine when LSP completion should be enabled or when MUcomplete should be
-- active.
-- TODO: Once we consolidate completion, these need to be adjusted.
local function should_lsp_be_enabled()
    local lsp_filetypes = { "python", "cpp", "lua", "cmake" }
    local common = require("common")

    return common.has_value(lsp_filetypes, vim.bo.filetype)
end

-- Used to enable/disable diagnostic functionality (i.e. the errors that come up when
-- linting). Currently only used in Python
local function should_diagnostic_be_enabled()
    local diagnostic_filetypes = { "python" }
    local common = require("common")

    return common.has_value(diagnostic_filetypes, vim.bo.filetype)
end

-- Toggles diagnostics on/off
local function enable_diagnostic(enable)
    if enable then
        vim.diagnostic.enable()
    else
        vim.diagnostic.disable()
    end
end

-- Toggles LSP on/off.
local function enable_lsp_autocomp(enable)
    local cmp = require("cmp")
    local cmp_action = require("lsp-zero").cmp_action()

    if enable then
        vim.cmd("execute 'MUcompleteAutoOff'")
        cmp.setup({
            enabled = function()
                local context = require("cmp.config.context")
                if
                    context.in_treesitter_capture("comment") == true
                    or context.in_syntax_group("Comment")
                then
                    return false
                else
                    return true
                end
            end,
            sources = {
                { name = "path" },
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "buffer", keyword_length = 3 },
            },
            mapping = {
                ["<Tab>"] = cmp_action.tab_complete(),
                ["<S-Tab>"] = cmp_action.select_prev_or_fallback(),
            },
        })
    else
        vim.cmd("execute 'MUcompleteAutoOn'")
        cmp.setup({ enabled = false })
    end
end

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

-- Don't enable folds on JSON files (it makes it harder to read).
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.json",
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
            vim.cmd("execute 'MUcompleteAutoOff'")                              -- Disable Mu-complete
            --stylua: ignore end
        end
    end,
})

-- Toggle lsp/diagnostics depending on filetype.
--vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave" }, {
--pattern = "*",
--group = augroup,
--callback = function(args)
--local enable_lsp = should_lsp_be_enabled()
--local enable_diag = should_diagnostic_be_enabled()
--if args.event == "BufEnter" then
--enable_diagnostic(enable_diag)
--enable_lsp_autocomp(enable_lsp)
--elseif args.event == "BufLeave" then
--enable_diagnostic(not enable_diag)
--enable_lsp_autocomp(not enable_lsp)
--end
--end,
--})

-- Ensure Mu-complete doesn't get enabled in Telescope windows.
--vim.api.nvim_create_autocmd({ "ModeChanged" }, {
--pattern = "*",
--group = augroup,
--callback = function()
--if vim.bo.filetype == "TelescopePrompt" then
--vim.cmd("execute 'MUcompleteAutoOff'")
--else
--if should_lsp_be_enabled() then
--vim.cmd("execute 'MUcompleteAutoOff'")
--else
--vim.cmd("execute 'MUcompleteAutoOn'")
--end
--end
--end,
--})

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
