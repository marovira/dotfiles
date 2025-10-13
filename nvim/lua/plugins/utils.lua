local common = require("common")

return {
    {
        "marovira/Navigator.nvim",
        lazy = false,
        opts = {
            disable_on_zoom = true,
        },
        keys = {
            {
                "<C-h>",
                "<cmd>NavigatorLeft<cr>",
                mode = "n",
                desc = "Navigate left",
            },
            {
                "<C-j>",
                "<cmd>NavigatorDown<cr>",
                mode = "n",
                desc = "Navigate down",
            },
            {
                "<C-k>",
                "<cmd>NavigatorUp<cr>",
                mode = "n",
                desc = "Navigate up",
            },
            {
                "<C-l>",
                "<cmd>NavigatorRight<cr>",
                mode = "n",
                desc = "Navigate right",
            },
        },
    },
    {
        "mrjones2014/smart-splits.nvim",
        version = "*",
        opts = {
            multiplexer_integartion = false,
        },
        keys = {
            {
                "<C-S-h>",
                function() require("smart-splits").resize_left(5) end,
                mode = "n",
                desc = "Resize split left",
            },
            {
                "<C-S-j>",
                function() require("smart-splits").resize_down(5) end,
                mode = "n",
                desc = "Resize split down",
            },
            {
                "<C-S-k>",
                function() require("smart-splits").resize_up(5) end,
                mode = "n",
                desc = "Resize split up",
            },
            {
                "<C-S-l>",
                function() require("smart-splits").resize_right(5) end,
                mode = "n",
                desc = "Resize split right",
            },
            {
                "<leader><leader>h",
                function() require("smart-splits").swap_buf_left() end,
                mode = "n",
                desc = "Swap buffer left",
            },
            {
                "<leader><leader>j",
                function() require("smart-splits").swap_buf_down() end,
                mode = "n",
                desc = "Swap buffer down",
            },
            {
                "<leader><leader>k",
                function() require("smart-splits").swap_buf_up() end,
                mode = "n",
                desc = "Swap buffer up",
            },
            {
                "<leader><leader>l",
                function() require("smart-splits").swap_buf_right() end,
                mode = "n",
                desc = "Swap buffer right",
            },
        },
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            -- Global pickers.
            {
                "<F7>",
                ---@diagnostic disable-next-line:missing-fields
                function() Snacks.explorer({ hidden = true }) end,
                desc = "Snacks explorer",
            },
            -- Find...
            {
                "<leader>fb",
                function() Snacks.picker.buffers() end,
                desc = "Find buffers",
            },
            {
                "<leader>ff",
                function() Snacks.picker.files({ hidden = true }) end,
                desc = "Find files",
            },
            {
                "<leader>fc",
                function()
                    Snacks.picker.files({ cwd = vim.fn.stdpath("config"), hidden = true })
                end,
                desc = "Find Config File",
            },
            {
                "<leader>fr",
                function() Snacks.picker.recent() end,
                desc = "Recent",
            },
            {
                "<leader>fs",
                function() Snacks.picker.smart() end,
                desc = "Smart Find Files",
            },
            -- Grep
            {
                "<leader>sb",
                function() Snacks.picker.lines() end,
                desc = "Buffer Lines",
            },
            {
                "<leader>sB",
                function() Snacks.picker.grep_buffers() end,
                desc = "Grep Open Buffers",
            },
            {
                "<leader>sg",
                function() Snacks.picker.grep() end,
                desc = "Grep",
            },
            {
                "<leader>sw",
                function() Snacks.picker.grep_word() end,
                desc = "Visual selection or word",
                mode = { "n", "x" },
            },
            -- Search
            {
                '<leader>s"',
                function() Snacks.picker.registers() end,
                desc = "Registers",
            },
            {
                "<leader>s/",
                function() Snacks.picker.search_history() end,
                desc = "Search History",
            },
            {
                "<leader>sa",
                function() Snacks.picker.autocmds() end,
                desc = "Autocmds",
            },
            {
                "<leader>sc",
                function() Snacks.picker.command_history() end,
                desc = "Command History",
            },
            {
                "<leader>sC",
                function() Snacks.picker.commands() end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function() Snacks.picker.diagnostics() end,
                desc = "Diagnostics",
            },
            {
                "<leader>sD",
                function() Snacks.picker.diagnostics_buffer() end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sh",
                function() Snacks.picker.help() end,
                desc = "Help Pages",
            },
            {
                "<leader>sH",
                function() Snacks.picker.highlights() end,
                desc = "Highlights",
            },
            {
                "<leader>si",
                function() Snacks.picker.icons() end,
                desc = "Icons",
            },
            {
                "<leader>sj",
                function() Snacks.picker.jumps() end,
                desc = "Jumps",
            },
            {
                "<leader>sk",
                function() Snacks.picker.keymaps() end,
                desc = "Keymaps",
            },
            {
                "<leader>sm",
                function() Snacks.picker.marks() end,
                desc = "Marks",
            },
            {
                "<leader>sn",
                function() Snacks.picker.notifications() end,
                desc = "Noice",
            },
            {
                "<leader>st",
                ---@diagnostic disable-next-line:undefined-field
                function() Snacks.picker.todo_comments() end,
                desc = "Todo",
            },
            {
                "<leader>su",
                function() Snacks.picker.undo() end,
                desc = "Undo History",
            },
            -- LSP
            {
                "gd",
                function() Snacks.picker.lsp_definitions() end,
                desc = "Goto Definition",
            },
            {
                "gD",
                function() Snacks.picker.lsp_declarations() end,
                desc = "Goto Declaration",
            },
            {
                "gr",
                function() Snacks.picker.lsp_references() end,
                nowait = true,
                desc = "References",
            },
            {
                "gi",
                function() Snacks.picker.lsp_implementations() end,
                desc = "Goto Implementation",
            },
            {
                "gy",
                function() Snacks.picker.lsp_type_definitions() end,
                desc = "Goto T[y]pe Definition",
            },
            {
                "<leader>ss",
                function() Snacks.picker.lsp_symbols() end,
                desc = "LSP Symbols",
            },
            {
                "<leader>sS",
                function() Snacks.picker.lsp_workspace_symbols() end,
                desc = "LSP Workspace Symbols",
            },
        },
        opts = {
            bigfile = {
                size = 100 * 1024 * 1024, -- 100MB for big files
            },
            dashboard = {
                preset = {
                    keys = {
                        {
                            icon = " ",
                            key = "f",
                            desc = "Find File",
                            action = ":lua Snacks.dashboard.pick('files', {hidden = true})",
                        },
                        {
                            icon = " ",
                            key = "n",
                            desc = "New File",
                            action = ":ene | startinsert",
                        },
                        {
                            icon = " ",
                            key = "g",
                            desc = "Find Text",
                            action = ":lua Snacks.dashboard.pick('live_grep')",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":lua Snacks.dashboard.pick('oldfiles')",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config'})",
                        },
                        {
                            icon = "󰒲 ",
                            key = "L",
                            desc = "Lazy",
                            action = ":Lazy",
                            enabled = package.loaded.lazy ~= nil,
                        },
                        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                    },
                },
                sections = {
                    { section = "header" },
                    {
                        icon = " ",
                        title = "Keymaps",
                        section = "keys",
                        indent = 2,
                        padding = 1,
                    },
                    {
                        section = "startup",
                    },
                },
            },
            picker = {
                formatters = {
                    file = {
                        filename_first = true,
                        truncate = 100,
                    },
                },
                sources = {
                    explorer = {
                        win = {
                            list = {
                                keys = {
                                    ["<c-s>"] = { { "pick_win", "edit_split" } },
                                    ["<c-v>"] = { { "pick_win", "edit_vsplit" } },
                                },
                            },
                        },
                    },
                },
                win = {
                    input = {
                        keys = {
                            ["O"] = { { "pick_win", "jump" }, mode = "n" },
                        },
                    },
                },
            },
            indent = {
                filter = function(buf)
                    return vim.g.snacks_indent ~= false
                        and vim.b[buf].snacks_indent ~= false
                        and vim.bo[buf].buftype == ""
                        and not common.is_filetype(buf, { "gitcommit" })
                end,
            },
            scroll = {},
            statuscolumn = {},
            scope = {},
            words = {},
            zen = {},
            image = {},
            notifier = {
                timeout = 3000,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    local Snacks = require("snacks")
                    _G.dd = function(...) Snacks.debug.inspect(...) end
                    _G.bt = function() Snacks.debug.backtrace() end
                    vim.print = _G.dd

                    Snacks.toggle.diagnostics():map("<leader>td")
                    Snacks.toggle.treesitter():map("<leader>tt")
                    Snacks.toggle.animate():map("<leader>ta")
                    Snacks.toggle.zen():map("<leader>tz")
                    Snacks.toggle.dim():map("<leader>th")
                    Snacks.toggle
                        .option("relativenumber", { name = "Relative number" })
                        :map("<leader>tn")
                    Snacks.toggle
                        .option("list", { name = "Whitespace characters" })
                        :map("<leader>tw")

                    Snacks.toggle
                        .new({
                            id = "noice_toggle",
                            name = "Noice",
                            get = function() return require("noice.config")._running end,
                            set = function(state)
                                if state then
                                    require("noice").enable()
                                else
                                    require("noice").disable()
                                end
                            end,
                        })
                        :map("<leader>tm")
                end,
            })

            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    Snacks.util.set_hl({
                        PickerDir = { link = "Comment" },
                        PickerPathHidden = { link = "Text" },
                        PickerPathIgnored = { link = "Comment" },
                    }, { prefix = "Snacks" })
                end,
            })
        end,
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            search = {
                mode = "exact",
            },
            modes = {
                search = { enabled = false },
            },
        },
        keys = {
            {
                "s",
                mode = { "n", "x", "o" },
                function() require("flash").jump() end,
                desc = "Flash",
            },
            {
                "S",
                mode = { "n", "x", "o" },
                function() require("flash").treesitter() end,
                desc = "Flash Treesitter",
            },
            {
                "r",
                mode = "o",
                function() require("flash").remote() end,
                desc = "Remote Flash",
            },
            {
                "R",
                mode = { "o", "x" },
                function() require("flash").treesitter_search() end,
                desc = "Treesitter Search",
            },
            {
                "<c-s>",
                mode = { "c" },
                function() require("flash").toggle() end,
                desc = "Toggle Flash Search",
            },
        },
    },
    {
        "m4xshen/hardtime.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        event = "VeryLazy",
        version = "*",
        opts = {
            disable_mouse = false,
            hints = {
                ["[dcyvV][ia][%(%)]"] = {
                    message = function(keys)
                        return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
                    end,
                    length = 3,
                },
                ["[dcyvV][ia][%{%}]"] = {
                    message = function(keys)
                        return "Use " .. keys:sub(1, 2) .. "B instead of " .. keys
                    end,
                    length = 3,
                },
            },
        },
    },
    {
        "folke/noice.nvim",
        dependencies = {
            { "MunifTanjim/nui.nvim", event = "VeryLazy" },
            {
                "rcarriga/nvim-notify",
                event = "VeryLazy",
                opts = { background_colour = "#000000" },
            },
        },
        event = "VeryLazy",
        opts = {
            routes = {
                {
                    -- Show @recording messages as a notify message
                    view = "notify",
                    filter = { event = "msg_showmode" },
                },
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        },
        keys = {
            {
                "<leader>nl",
                function() require("noice").cmd("last") end,
                desc = "Noice last message",
            },
            {
                "<leader>nh",
                function() require("noice").cmd("history") end,
                desc = "Noice message history",
            },
        },
    },
    {
        "nvim-mini/mini.nvim",
        version = false,
        config = function()
            require("mini.pairs").setup({})
            require("mini.surround").setup({})
            require("mini.icons").setup({})
        end,
    },
}
