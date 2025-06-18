local noice_enabled = true
local common = require("common")

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "numToStr/Navigator.nvim",
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
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {
            highlight = { keyword = "fg" },
        },
    },
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            {
                "<leader>fu",
                function() require("snacks").picker.undo() end,
                desc = "Find undo",
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
                            action = ":FzfLua files",
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
                            action = ":FzfLua live_grep",
                        },
                        {
                            icon = " ",
                            key = "r",
                            desc = "Recent Files",
                            action = ":FzfLua oldfiles",
                        },
                        {
                            icon = " ",
                            key = "c",
                            desc = "Config",
                            action = ":lua FzfLua.files({cwd = vim.fn.stdpath('config')})",
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
            picker = {},
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
                    Snacks.toggle.zen():map("<leader>tz")
                    Snacks.toggle
                        .option("relativenumber", { name = "Relative number" })
                        :map("<leader>tn")
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
            {
                "<leader>fm",
                function() require("noice").cmd("fzf") end,
                desc = "Find noice messages",
            },
            {
                "<leader>nt",
                function()
                    if noice_enabled then
                        require("noice").cmd("disable")
                        noice_enabled = false
                    else
                        require("noice").cmd("enable")
                        noice_enabled = true
                    end
                end,
                desc = "Toggle noice",
            },
        },
    },
}
