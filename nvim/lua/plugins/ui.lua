local common = require("common")

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
        config = function(_, opts) require("lualine").setup(opts) end,
        opts = {
            options = {
                theme = "tokyonight",
                disabled_filetypes = {
                    statusline = {
                        "Trouble",
                        "gitcommit",
                        "snacks_picker_list",
                    },
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    { "branch", icon = "" },
                    {
                        "diff",
                        symbols = {
                            added = " ",
                            modified = " ",
                            removed = " ",
                        },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic", "ale" },
                    },
                },
                lualine_c = {
                    {
                        "filename",
                        path = 1,
                        symbols = {
                            modified = "",
                            readonly = "",
                            unnamed = "",
                            newfile = "",
                        },
                    },
                },
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
                    { pattern = "highlight", icon = "󰸱" },
                    { pattern = "resume", icon = "" },
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
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")

            -- State tracking for async parser loading
            local parsers_loaded = {}
            local parsers_pending = {}
            local parsers_failed = {}

            local ns = vim.api.nvim_create_namespace("treesitter.async")

            -- Helper to start highlighting and indentation
            ---@param buf integer
            ---@param lang string
            local function start(buf, lang)
                local ok = pcall(vim.treesitter.start, buf, lang)
                if ok and not common.is_buffer_filetype({ "toml", "python" }, buf) then
                    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
                return ok
            end

            -- Install core parsers after lazy.nvim finishes loading all plugins
            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyDone",
                once = true,
                callback = function()
                    ts.install({
                        "bash",
                        "c",
                        "cmake",
                        "comment",
                        "cpp",
                        "diff",
                        "git_config",
                        "git_rebase",
                        "gitignore",
                        "glsl",
                        "javascript",
                        "json",
                        "latex",
                        "lua",
                        "luadoc",
                        "make",
                        "markdown",
                        "markdown_inline",
                        "objc",
                        "python",
                        "query",
                        "regex",
                        "rust",
                        "toml",
                        "vim",
                        "vimdoc",
                        "xml",
                    }, {
                        max_jobs = 8,
                    })
                end,
            })

            -- Decoration provider for async parser loading
            vim.api.nvim_set_decoration_provider(ns, {
                on_start = vim.schedule_wrap(function()
                    if #parsers_pending == 0 then return false end
                    for _, data in ipairs(parsers_pending) do
                        if vim.api.nvim_buf_is_valid(data.buf) then
                            if start(data.buf, data.lang) then
                                parsers_loaded[data.lang] = true
                            else
                                parsers_failed[data.lang] = true
                            end
                        end
                    end
                    parsers_pending = {}
                end),
            })

            local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

            local ignore_filetypes = {
                "gitcommit",
                "blink-cmp-documentation",
                "blink-cmp-menu",
                "blink-cmp-signature",
                "checkhealth",
                "lazy",
                "mason",
                "noice",
                "snacks_dashboard",
                "snacks_layout_box",
                "snacks_notif",
                "snacks_picker_input",
                "snacks_picker_list",
                "snacks_picker_preview",
                "snacks_win",
            }

            -- Auto-install parsers and enable highlighting on FileType
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                desc = "Enable treesitter highlighting and indentation (non-blocking)",
                callback = function(event)
                    if vim.tbl_contains(ignore_filetypes, event.match) then return end

                    local lang = vim.treesitter.language.get_lang(event.match)
                        or event.match
                    local buf = event.buf

                    if parsers_failed[lang] then return end

                    if parsers_loaded[lang] then
                        -- Parser already loaded, start immediately (fast path)
                        start(buf, lang)
                    else
                        -- Queue for async loading
                        table.insert(parsers_pending, { buf = buf, lang = lang })
                    end

                    -- Auto-install missing parsers (async, no-op if already installed)
                    ts.install({ lang })
                end,
            })
        end,
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter",
    --     build = function()
    --         require("nvim-treesitter.install").update({ with_sync = true })()
    --     end,
    --     config = function()
    --         local configs = require("nvim-treesitter.configs")
    --
    --         ---@diagnostic disable: missing-fields
    --         configs.setup({
    --             ensure_installed = {
    --                 "c",
    --                 "cpp",
    --                 "lua",
    --                 "vim",
    --                 "vimdoc",
    --                 "query",
    --                 "python",
    --                 "cmake",
    --                 "glsl",
    --                 "bash",
    --                 "git_config",
    --                 "objc",
    --             },
    --             sync_install = false,
    --             auto_install = true,
    --             highlight = {
    --                 enable = true,
    --                 disable = { "gitcommit", "latex" },
    --             },
    --         })
    --     end,
    -- },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        opts = {
            options = {
                show_source = {
                    enabled = true,
                    if_many = true,
                },
                use_icons_from_diagnostic = true,
            },
        },
        config = function(_, opts)
            require("tiny-inline-diagnostic").setup(opts)
            vim.diagnostic.config({
                virtual_text = false,
                float = false,
            })
        end,
    },
}
