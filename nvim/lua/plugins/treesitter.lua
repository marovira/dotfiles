local config = function()
    local configs = require("nvim-treesitter.configs")

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
            disable = { "gitcommit", "markdown", "latex" },
        },
    })
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = config,
    },
}
