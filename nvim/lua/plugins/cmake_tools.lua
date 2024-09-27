return {
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            { "mfussenegger/nvim-dap" },
            { "akinsho/toggleterm.nvim" },
        },
        config = function()
            require("cmake-tools").setup({
                cmake_build_directory = "build",
            })
        end,
    },
}
