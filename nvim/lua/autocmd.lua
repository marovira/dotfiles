local common = require("common")

-- UI Autocmds
-- =======================
local ui_group = vim.api.nvim_create_augroup("nvimrc_ui", { clear = true })

vim.api.nvim_create_autocmd({ "VimEnter", "VimLeavePre" }, {
    pattern = "*",
    group = ui_group,
    callback = function(args)
        if args.event == "VimEnter" then
            common.set_wezterm_user_var("IS_NVIM", true)
        else
            common.set_wezterm_user_var("IS_NVIM", false)
        end
    end,
})

-- If using Neovide, ensure that the opacity is set to 1 on focus lost so we don't get
-- weird colours due to the window blur.
vim.api.nvim_create_autocmd({ "FocusGained", "FocusLost" }, {
    pattern = "*",
    group = ui_group,
    callback = function(args)
        if vim.g.neovide and common.is_windows() then
            if args.event == "FocusGained" then
                vim.g.neovide_opacity = 0.5
            else
                vim.g.neovide_opacity = 1
            end
        end
    end,
})

-- Switch to absolute line numbers in insert mode.
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
    pattern = "*",
    group = ui_group,
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
    group = ui_group,
    callback = function()
        if common.is_buffer_filetype({ "snacks_picker_list" }) then return end
        vim.opt.number = true
        vim.opt.relativenumber = true
    end,
})

-- File-type Autocmd
-- =======================
local ft_group = vim.api.nvim_create_augroup("nvimrc_ft", { clear = true })

-- Treat all h/c files as C++. In the event I ever write C again, this will be changed
-- accordingly.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { ".h", "*.c" },
    group = ft_group,
    command = "set filetype=cpp",
})

-- Property sheets prefer 2 spaces instead of 4, so override those settings while ensuring
-- they get treated as XML files.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.props" },
    group = ft_group,
    callback = function()
        vim.cmd("set filetype=xml")
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- Ensure GLSL shader files are appropriately recognised.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.vert", "*.tesc", "*.tese", "*.geom", "*.frag", "*.comp" },
    group = ft_group,
    command = "set filetype=glsl",
})

-- Allow detection of Objective C++.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = "*.mm",
    group = ft_group,
    command = "set filetype=objc",
})

-- Set .tmux files to tmux
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.tmux" },
    group = ft_group,
    command = "set filetype=tmux",
})

-- Disable folds in JSON and markdown.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.json", "*.md" },
    group = ft_group,
    command = "silent! :set nofoldenable",
})

-- Disable text width in DAP buffers.
vim.api.nvim_create_autocmd({ "BufEnter" }, {
    pattern = { "*" },
    group = ft_group,
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

-- LSP Autocmd
-- =======================
local lsp_group = vim.api.nvim_create_augroup("nvimrc_lsp", { clear = true })

vim.api.nvim_create_autocmd({ "LspAttach" }, {
    group = lsp_group,
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
        vim.keymap.set(
            "n",
            "gl",
            function() vim.diagnostic.open_float() end,
            { desc = "LSP diagnostic open float" }
        )
        vim.keymap.set(
            "n",
            "[d",
            function()
                vim.diagnostic.jump({
                    count = -1,
                    float = false,
                })
            end,
            { desc = "LSP go to previous diagnostic" }
        )
        vim.keymap.set(
            "n",
            "]d",
            function()
                vim.diagnostic.jump({
                    count = 1,
                    float = false,
                })
            end,
            { desc = "LSP go to next diagnostic" }
        )
    end,
})

-- Util Autocmd
-- =======================
local util_group = vim.api.nvim_create_augroup("nvimrc_util", { clear = true })

-- On Windows only, ensure empty ShaDa files are cleared on exit. This prevents the "can't
-- save because of ShaDa" errors.
vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
    pattern = { "*" },
    group = util_group,
    callback = function()
        if not common.is_windows() then return end

        local status = 0
        for _, f in
            ipairs(
                vim.fn.glob(
                    vim.fn.expand(vim.fn.stdpath("data") .. "/shada") .. "/*",
                    false,
                    true
                )
            )
        do
            if vim.tbl_isempty(vim.fn.readfile(f)) then
                status = status + vim.fn.delete(f)
            end
        end
        if status ~= 0 then
            vim.notify(
                "Could not delete empty temporary ShaDa files",
                vim.log.levels.ERROR
            )
            vim.fn.getchar()
        end
    end,
    desc = "Delete empty ShaDa files",
})

-- Makes it so neovim reloads the file whenever a change has been made externally.
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    group = util_group,
    callback = function()
        if vim.fn.mode() ~= "c" then vim.api.nvim_command("checktime") end
    end,
})
