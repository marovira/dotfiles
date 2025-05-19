local common = require("common")
local noice_enabled = true

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
    },
    {
        "opdavies/toggle-checkbox.nvim",
        keys = {
            {
                "<leader>tc",
                function() require("toggle-checkbox").toggle() end,
                mode = "n",
                ft = "markdown",
                desc = "Toggle checkbox",
            },
        },
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
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "mfussenegger/nvim-dap" },
            { "akinsho/toggleterm.nvim" },
        },
        opts = {
            cmake_build_directory = "build",
        },
        keys = {
            {
                "<leader>mg",
                "<cmd>CMakeGenerate<cr>",
                desc = "CMake generate",
            },
            {
                "<leader>mb",
                "<cmd>CMakeBuild<cr>",
                desc = "CMake build",
            },
            {
                "<leader>mr",
                "<cmd>CMakeRun<cr>",
                desc = "CMake run",
            },
        },
    },
    {
        "akinsho/toggleterm.nvim",
        opts = {
            shell = function()
                -- Force the shell to be bash on windows.
                if common.is_windows() then
                    return "bash"
                else
                    return vim.o.shell
                end
            end,
            open_mapping = "<C-\\>",
            start_in_insert = true,
            direction = "float",
            close_on_exit = true,
        },
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = {
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        keys = {
            {
                "<leader>fu",
                "<cmd>Telescope undo<cr>",
                desc = "Telescope undo",
            },
        },
        opts = {
            extensions = {
                undo = {
                    use_delta = true,
                    side_by_side = true,
                    vim_diff_opts = { ctxlen = 10 },
                    layout_strategy = "vertical",
                    layout_config = {
                        preview_height = 0.8,
                    },
                },
            },
        },
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("undo")
        end,
    },
    {
        "da-moon/telescope-toggleterm.nvim",
        event = "TermOpen",
        dependencies = {
            { "akinsho/nvim-toggleterm.lua" },
            { "nvim-telescope/telescope.nvim" },
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
        },
        keys = {
            {
                "<leader>ft",
                "<cmd>Telescope toggleterm<cr>",
                desc = "Telescope toggleterm",
            },
        },
        opts = {},
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension("toggleterm")
        end,
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
        opts = {
            bigfile = {
                enabled = true,
                size = 100 * 1024 * 1024, -- 100MB for big files
            },
        },
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
