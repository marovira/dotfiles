local common = require("common")

-- Autocommands
-- =======================
local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    pattern = "*",
    group = augroup,
    callback = function() common.set_wezterm_user_var("IS_NVIM", false) end,
})

-- Makes it so neovim reloads the file whenever a change has been made externally.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if vim.fn.mode() ~= "c" then vim.api.nvim_command("checktime") end
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

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.rs" },
    group = augroup,
    callback = function() vim.opt_local.textwidth = 90 end,
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
    command = "set filetype=objc",
})

-- Set .tmux files to tmux
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.tmux" },
    group = augroup,
    command = "set filetype=tmux",
})

-- Disable folds in JSON and markdown.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.json", "*.md" },
    group = augroup,
    command = "silent! :set nofoldenable",
})

-- Disable text width in DAP buffers.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    group = augroup,
    callback = function(opts)
        if
            common.is_buffer_filetype(
                { "dap-repl", "dapui_watches", "dap-terminal" },
                opts.buf
            )
        then
            vim.opt_local.textwidth = 0
        end
    end,
})

-- Switch to absolute line numbers in insert mode.
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        -- Don't mess with the line numbers in the snacks pickers.
        if common.is_buffer_filetype({ "snacks_picker_list" }) then return end
        vim.opt.relativenumber = false
        vim.opt.number = true
    end,
})

-- Switch back to relative numbers in normal mode.
vim.api.nvim_create_autocmd({ "InsertLeave", "BufNewFile", "VimEnter" }, {
    pattern = "*",
    group = augroup,
    callback = function()
        if common.is_buffer_filetype({ "snacks_picker_list" }) then return end
        vim.opt.number = true
        vim.opt.relativenumber = true
    end,
})

-- LSP autocmd
vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = augroup,
    desc = "LSP actions",
    callback = function(event)
        vim.keymap.set(
            "n",
            "K",
            "<cmd>lua vim.lsp.buf.hover()<cr>",
            { buffer = event.buf, desc = "LSP hover" }
        )
        vim.keymap.set(
            "n",
            "gs",
            "<cmd>lua vim.lsp.buf.signature_help()<cr>",
            { buffer = event.buf, desc = "LSP signature help" }
        )
        vim.keymap.set(
            "n",
            "<F2>",
            "<cmd>lua vim.lsp.buf.rename()<cr>",
            { buffer = event.buf, desc = "LSP rename" }
        )
        vim.keymap.set(
            { "n", "x" },
            "<F3>",
            "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
            { buffer = event.buf, desc = "LSP format" }
        )
        vim.keymap.set(
            "n",
            "<F4>",
            "<cmd>lua vim.lsp.buf.code_action()<cr>",
            { buffer = event.buf, desc = "LSP code action" }
        )
    end,
})
