return {
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
}
