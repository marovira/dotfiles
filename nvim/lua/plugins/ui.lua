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
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "nvim-mini/mini.nvim" },
        },
        config = function(_, opts)
            require("mini.icons").mock_nvim_web_devicons()
            require("lualine").setup(opts)
        end,
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
        "folke/trouble.nvim",
        dependencies = {
            { "nvim-mini/mini.nvim" },
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
                "<leader>xL",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Trouble loclist",
            },
            {
                "<leader>xQ",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Trouble quickfix",
            },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            icons = {
                rules = {
                    { pattern = "explorer", icon = "󰙅" },
                    { pattern = "command", icon = "" },
                    { pattern = "autocmds", icon = "" },
                    { pattern = "dap", icon = "" },
                    { pattern = "cmake", icon = "" },
                    { pattern = "clang", icon = "" },
                    { pattern = "smart", icon = "" },
                    { pattern = "files", icon = "" },
                    { pattern = "todo", icon = "" },
                    { pattern = "help", icon = "󰋖" },
                    { pattern = "diagnostics", icon = "󱖫" },
                    { pattern = "buffer", icon = "" },
                    { pattern = "grep", icon = "" },
                    { pattern = "global", icon = "󱢎" },
                    { pattern = "lsp", icon = "" },
                    { pattern = "symbol", icon = "" },
                    { pattern = "icons", icon = "" },
                    { pattern = "keymaps", icon = "" },
                    { pattern = "undo", icon = "" },
                    { pattern = "history", icon = "" },
                    { pattern = "noice", icon = "󰈸", color = "orange" },
                    { pattern = "config", icon = " " },
                    { pattern = "marks", icon = "" },
                    { pattern = "jumps", icon = "󰓾" },
                    { pattern = "word", icon = "" },
                    { pattern = "recent", icon = "" },
                },
            },
        },
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer Local Keymaps (which-key)",
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
