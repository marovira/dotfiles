return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
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
            })
        end,
    },
}
