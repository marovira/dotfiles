return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "moon",
            transparent = not vim.g.neovide,
            styles = {
                floats = "transparent",
                sidebars = "transparent",
            },
            dim_inactive = true,
            luanline_bold = true,
            on_colors = function(colors)
                local util = require("tokyonight.util")
                colors.fg_gutter = util.lighten(colors.fg_gutter, 0.8)
            end,
            on_highlights = function(hl, colors)
                hl.SpellBad = {
                    fg = colors.red,
                }
            end,
        },
        init = function() vim.cmd("colorscheme tokyonight") end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            options = {
                theme = "tokyonight",
                disabled_filetypes = {
                    statusline = {
                        "NvimTree",
                        "Trouble",
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
                lualine_y = { "progress", "selectioncount" },
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
        "nvim-tree/nvim-tree.lua",
        lazy = false,
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
        opts = {
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                api.config.mappings.default_on_attach(bufnr)

                vim.keymap.set("n", "<C-s>", api.node.open.horizontal, {
                    desc = "Open: Horizontal Split",
                    buffer = bufnr,
                    noremap = true,
                    silent = true,
                    nowait = true,
                })
                vim.keymap.del("n", "<C-x>", { buffer = bufnr })
            end,
        },
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
                desc = "Trouble diagnostics",
            },
            {
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Trouble buffer diagnostics",
            },
            {
                "<leader>xs",
                "<cmd>Trouble symbols toggle focus=false<cr>",
                desc = "Trouble symbols",
            },
            {
                "<leader>xl",
                "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "Trouble LSP definitions / references",
            },
            {
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Trouble loclist",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Trouble quickfix",
            },
            {
                "<leader>xt",
                "<cmd>Trouble todo<cr>",
                desc = "Trouble TODO",
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
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            "default",
            hls = { backdrop = nil },
        },
        config = function(_, opts)
            require("fzf-lua").setup(opts)
            vim.ui.select = require("fzf-lua.providers.ui_select").ui_select
        end,
        keys = {
            {
                "<leader>ff",
                "<cmd>FzfLua files<cr>",
                desc = "FZF files",
            },
            {
                "<leader>fg",
                "<cmd>FzfLua live_grep<cr>",
                desc = "FZF live grep",
            },
            {
                "<leader>fG",
                "<cmd>FzfLua live_grep_resume<cr>",
                desc = "FZF resume live grep",
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
                "<leader>fr",
                "<cmd>FzfLua lsp_references<cr>",
                desc = "FZF find references",
            },
            {
                "<leader>fs",
                "<cmd>FzfLua lsp_document_symbols<cr>",
                desc = "FZF LSP document symbols",
            },
            {
                "<leader>fS",
                "<cmd>FzfLua lsp_workspace_symbols<cr>",
                desc = "FZF LSP workspace symbols",
            },
            {
                "<leader>fl",
                "<cmd>FzfLua lsp_finder<cr>",
                desc = "FZF LSP finder",
            },
            {
                "<leader>fdv",
                "<cmd>FzfLua dap_variables<cr>",
                desc = "FZF DAP active session variables",
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
