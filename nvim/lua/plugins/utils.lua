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
        "j-hui/fidget.nvim",
        version = "*",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                },
            },
        },
    },
    {
        "ggandor/leap.nvim",
        config = function()
            local leap = require("leap")
            leap.opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
            leap.opts.preview_filter = function(ch0, ch1, ch2)
                return not (
                    ch1:match("%s")
                    or ch0:match("%w") and ch1:match("%w") and ch2:match("%w")
                )
            end

            require("leap.user").set_repeat_keys("<enter>", "<backspace>")

            vim.keymap.set(
                { "n", "x", "o" },
                "s",
                "<Plug>(leap-forward)",
                { desc = "Leap forward" }
            )
            vim.keymap.set(
                { "n", "x", "o" },
                "S",
                "<Plug>(leap-backward)",
                { desc = "Leap backward" }
            )
        end,
    },
}
