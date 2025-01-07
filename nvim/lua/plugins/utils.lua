local common = require("common")

return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
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
        "Konfekt/FastFold",
        init = function()
            vim.g.fastfold_savehook = true
            vim.g.markdown_folding = true
            vim.g.tex_fold_enabled = true
        end,
    },
    {
        "alexghergh/nvim-tmux-navigation",
        opts = {
            disable_when_zoomed = true,
            keybindings = {
                left = "<C-h>",
                down = "<C-j>",
                up = "<C-k>",
                right = "<C-l>",
            },
        },
    },
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = true,
                },
                char = {
                    jump_labels = true,
                },
            },
        },
        keys = {
            {
                "<leader>s",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump({
                        search = {
                            forward = true,
                            wrap = false,
                            multi_window = false,
                        },
                    })
                end,
                desc = "Flash forward search",
            },
            {
                "<leader>S",
                mode = { "n", "x", "o" },
                function()
                    require("flash").jump({
                        search = {
                            forward = false,
                            wrap = false,
                            multi_window = false,
                        },
                    })
                end,
                desc = "Flash backward search",
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
                "<leader>t",
                "<cmd>Telescope toggleterm<cr>",
                desc = "Telescope toggleterm",
            },
        },
        config = function() require("telescope").load_extension("toggleterm") end,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
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
        dependencies = {
            { "MunifTanjim/nui.nvim", event = "VeryLazy" },
            {
                "rcarriga/nvim-notify",
                event = "VeryLazy",
                opts = { background_colour = "#000000" },
            },
        },
    },
}
