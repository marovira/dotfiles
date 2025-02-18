return {
    {
        "dracula/vim",
        lazy = false,
        priority = 1000,
        init = function()
            vim.g.dracula_colorterm = false
            vim.cmd("colorscheme dracula")
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = { char = "│" },
            scope = { show_end = false },
            exclude = {
                filetypes = {
                    "lspinfo",
                    "packer",
                    "checkhealth",
                    "help",
                    "man",
                    "gitcommit",
                    "TelescopePrompt",
                    "TelescopeResults",
                    "",
                    "startify",
                },
            },
        },
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            options = {
                theme = "dracula",
                disabled_filetypes = {
                    statusline = {
                        "NvimTree",
                        "Trouble",
                        "startify",
                        "gitcommit",
                    },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    "diff",
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic", "ale" },
                    },
                },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress", "selectioncount", "searchcount" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
        },
    },
    {
        "mhinz/vim-startify",
        init = function()
            vim.g.startify_skiplist = { "COMMIT_EDITMSG" }
            vim.g.startify_change_to_dir = false
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        config = true,
        keys = {
            {

                "<F7>",
                function() require("nvim-tree.api").tree.toggle() end,
                mode = "n",
                desc = "Toggle NVimTree",
            },
        },
    },
    {
        "folke/trouble.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            auto_close = true,
        },
        cmd = "Trouble",
        keys = {
            {
                "<leader>xx",
                "<cmd>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = true,
        keys = {
            {
                "<leader>ff",
                "<cmd>FzfLua files<cr>",
                desc = "FZF files",
            },
            {
                "<leader>fg",
                "<cmd>FzfLua grep<cr><cr>",
                desc = "FZF live grep",
            },
            {
                "<leader>fb",
                "<cmd>FzfLua buffers<cr>",
                desc = "FZF buffers",
            },
            {
                "<leader>fh",
                "<cmd>FzfLua helptags<cr>",
                desc = "FZF help tags",
            },
            {
                "gr",
                "<cmd>FzfLua lsp_references<cr>",
                desc = "FZF find references",
            },
            {
                "<leader>fs",
                "<cmd>FzfLua lsp_document_symbols<cr>",
                desc = "FZF LSP document symbols",
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })()
        end,
        config = function()
            local configs = require("nvim-treesitter.configs")

            ---@diagnostic disable: missing-fields
            configs.setup({
                ensure_installed = {
                    "c",
                    "cpp",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "python",
                    "cmake",
                    "glsl",
                    "bash",
                    "git_config",
                    "objc",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "gitcommit", "latex" },
                },
            })
        end,
    },
}
