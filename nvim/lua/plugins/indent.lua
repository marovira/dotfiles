local opts = {
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
}

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = opts,
    },
}
